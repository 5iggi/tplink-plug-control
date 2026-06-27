package tplink_lib;
use strict;
use warnings;
use IO::Socket::INET;
use Socket qw(AF_INET SOCK_DGRAM SOL_SOCKET SO_BROADCAST sockaddr_in inet_ntoa INADDR_BROADCAST);
use JSON qw(decode_json encode_json);
use File::Path qw(make_path);
use Exporter 'import';
our @EXPORT_OK = qw(paths get_lang read_config write_config logmsg tplink_cmd discover_devices sanitize_name xml_escape extract_value loxberry_base_url);

sub paths {
    my $h = $ENV{LBHOMEDIR} || '/opt/loxberry';
    return (
        home  => $h,
        conf  => $ENV{LBPCONFIGDIR} || "$h/config/plugins/tplink",
        log   => $ENV{LBPLOGDIR}    || "$h/log/plugins/tplink",
        templ => $ENV{LBPTEMPLDIR}  || (($ENV{LBPTEMPL} || "$h/templates/plugins") . "/tplink"),
    );
}
sub get_lang { my $s = $ENV{HTTP_ACCEPT_LANGUAGE} || $ENV{LANG} || 'de'; return ($s =~ /^en/i) ? 'en' : 'de'; }
sub logmsg {
    my ($level,$msg)=@_; my %p=paths(); make_path($p{log});
    $level='INFO' unless $level =~ /^(OK|INFO|WARNING|ERROR|FAIL)$/;
    if(open(my $fh,'>>',"$p{log}/tplink.log")) { print $fh scalar(localtime())." <$level> $msg\n"; close $fh; }
}
sub read_config {
    my %p=paths(); my $f="$p{conf}/devices.json";
    return {devices=>[]} if !-e $f;
    local $/; open(my $fh,'<',$f) or return {devices=>[]}; my $txt=<$fh>; close $fh;
    my $cfg=eval{decode_json($txt)} || {devices=>[]}; $cfg->{devices} ||= []; return $cfg;
}
sub write_config {
    my($cfg)=@_; my %p=paths(); make_path($p{conf});
    open(my $fh,'>',"$p{conf}/devices.json") or die "Cannot write devices.json: $!";
    print $fh encode_json($cfg); close $fh;
}
sub enc { my($s,$tcp)=@_; my $k=171; my $r=$tcp ? pack('N',length($s)) : ''; for(split //,$s){ my $c=ord($_)^$k; $k=$c; $r.=chr($c); } return $r; }
sub dec { my($s)=@_; my $k=171; my $r=''; for(split //,$s){ my $c=ord($_); my $d=$c^$k; $k=$c; $r.=chr($d); } return $r; }
sub cmd_json {
    my($cmd,$arg)=@_; my($sec,$min,$hour,$mday,$mon,$year)=localtime; $mon++; $year+=1900;
    my %c=(
      on=>'{"system":{"set_relay_state":{"state":1}}}',
      off=>'{"system":{"set_relay_state":{"state":0}}}',
      state=>'{"system":{"get_sysinfo":{}}}',
      info=>'{"system":{"get_sysinfo":{}}}',
      led_on=>'{"system":{"set_led_off":{"off":0}}}',
      led_off=>'{"system":{"set_led_off":{"off":1}}}',
      reboot=>'{"system":{"reboot":{"delay":1}}}',
      reset=>'{"system":{"reset":{"delay":1}}}',
      time=>'{"time":{"get_time":{}}}',
      realtime=>'{"emeter":{"get_realtime":{}}}',
      power=>'{"emeter":{"get_realtime":{}}}',
      voltage=>'{"emeter":{"get_realtime":{}}}',
      current=>'{"emeter":{"get_realtime":{}}}',
      energy=>'{"emeter":{"get_realtime":{}}}',
      cloudinfo=>'{"cnCloud":{"get_info":{}}}',
      wlanscan=>'{"netif":{"get_scaninfo":{"refresh":0}}}',
      wlanscanfresh=>'{"netif":{"get_scaninfo":{"refresh":1}}}',
    );
    if($cmd eq 'settime' && ref($arg) eq 'HASH') { return encode_json({time=>{set_timezone=>$arg}}); }
    return $c{$cmd};
}
sub tplink_cmd {
    my($ip,$cmd,$arg,$timeout)=@_; $timeout ||= 4;
    my $j=cmd_json($cmd,$arg); return (0,undef,'Invalid command') unless $j;
    my $sock=IO::Socket::INET->new(PeerAddr=>$ip,PeerPort=>9999,Proto=>'tcp',Type=>SOCK_STREAM,Timeout=>$timeout);
    return (0,undef,"Connection failed to $ip") unless $sock;
    $sock->send(enc($j,1)); my $resp=''; $sock->recv($resp,32768); close $sock;
    return (0,undef,'Empty response') unless $resp;
    my $plain=dec(substr($resp,4)); my $obj=eval{decode_json($plain)};
    return $obj ? (1,$obj,$plain) : (0,undef,"JSON decode failed: $plain");
}
sub first_defined { for(@_){ return $_ if defined $_; } return undef; }
sub extract_value {
    my($cmd,$obj)=@_; return undef unless $obj;
    return $obj->{system}{get_sysinfo}{relay_state} if $cmd eq 'state';
    my $e=$obj->{emeter}{get_realtime} || {};
    return first_defined($e->{power_mw}?$e->{power_mw}/1000:undef,$e->{power},$e->{power_w}) if $cmd eq 'power';
    return first_defined($e->{voltage_mv}?$e->{voltage_mv}/1000:undef,$e->{voltage},$e->{voltage_v}) if $cmd eq 'voltage';
    return first_defined($e->{current_ma}?$e->{current_ma}/1000:undef,$e->{current},$e->{current_a}) if $cmd eq 'current';
    return first_defined($e->{total_wh}?$e->{total_wh}/1000:undef,$e->{total},$e->{total_energy},$e->{energy}) if $cmd eq 'energy';
    return undef;
}
sub sanitize_name { my $s=shift || 'device'; $s =~ s/^\s+|\s+$//g; $s =~ s/[^A-Za-z0-9_.-]+/_/g; return lc($s); }
sub xml_escape { my $s=shift; $s='' unless defined $s; $s=~s/&/&amp;/g; $s=~s/</&lt;/g; $s=~s/>/&gt;/g; $s=~s/"/&quot;/g; return $s; }
sub loxberry_base_url { my $h=$ENV{HTTP_HOST}||$ENV{SERVER_NAME}||$ENV{SERVER_ADDR}||'LOXBERRY'; $h =~ s/\s+//g; my $scheme=($ENV{HTTPS}&&$ENV{HTTPS} ne 'off')?'https':'http'; return "$scheme://username:password\@$h"; }
sub discover_devices {
    my($timeout)=@_; $timeout ||= 5; my @found; my $payload=enc('{"system":{"get_sysinfo":{}}}',0);
    socket(my $sock,AF_INET,SOCK_DGRAM,0) or return \@found; setsockopt($sock,SOL_SOCKET,SO_BROADCAST,pack('i',1));
    send($sock,$payload,0,sockaddr_in(9999,INADDR_BROADCAST)); my $rin=''; vec($rin,fileno($sock),1)=1; my $end=time+$timeout;
    while(time<$end){ my $rout=$rin; my $n=select($rout,undef,undef,$end-time); last if !$n; my $buf=''; my $peer=recv($sock,$buf,8192,0); next unless $buf; my $ip=''; eval{ my($p,$ia)=sockaddr_in($peer); $ip=inet_ntoa($ia) if $ia; }; my $o=eval{decode_json(dec($buf))}; next unless $o && $o->{system}{get_sysinfo}; my $si=$o->{system}{get_sysinfo}; push @found,{ip=>$ip,alias=>$si->{alias}||$ip,model=>$si->{model}||'',mac=>$si->{mac}||$si->{mic_mac}||'',relay_state=>$si->{relay_state}}; }
    close $sock; my %seen; @found=grep{!$seen{$_->{ip}}++}@found; return \@found;
}
1;
