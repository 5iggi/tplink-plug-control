#!/usr/bin/perl
use strict;use warnings;use CGI;use HTML::Template;use FindBin;
use lib "$FindBin::Bin/../../../../bin/plugins/tplink";use lib "/opt/loxberry/bin/plugins/tplink";
use tplink_lib qw(read_config write_config discover_devices sanitize_name xml_escape paths loxberry_base_url logmsg);
my $q=CGI->new;my $action=$q->param('action')||'';my %p=paths();
my $LBW=eval{require LoxBerry::Web; LoxBerry::Web->import(); 1}; my $LBS=eval{require LoxBerry::System; LoxBerry::System->import(); 1};
sub start { my $t=shift||'TP-Link Plug Control'; if($LBW){ LoxBerry::Web::lbheader($t,'',''); } else { print $q->header(-type=>'text/html',-charset=>'utf-8'); print '<html><body>'; } }
sub finish { if($LBW){ LoxBerry::Web::lbfooter(); } else { print '</body></html>'; } }
sub render { my($file,$vars)=@_; my $t=HTML::Template->new(filename=>"$p{templ}/$file",global_vars=>1,loop_context_vars=>1,die_on_bad_params=>0); eval{LoxBerry::System::readlanguage($t,'language.ini')} if $LBS; $t->param(%$vars); print $t->output; }
if($action eq 'save'){
  my $cfg=read_config(); my @n=$q->param('name'); my @ip=$q->param('ip'); my @ty=$q->param('type'); my @e=$q->param('enabled_idx'); my %en=map{$_=>1}@e; my @d;
  for(my $i=0;$i<@ip;$i++){ next unless $ip[$i]; push @d,{id=>sanitize_name($n[$i]||$ip[$i]),name=>$n[$i]||$ip[$i],ip=>$ip[$i],type=>$ty[$i]||'auto',enabled=>$en{$i}?1:0}; }
  $cfg->{devices}=\@d; write_config($cfg); logmsg('OK','Configuration saved'); print $q->redirect('index.cgi?saved=1'); exit;
}
if($action eq 'discover'){
  my $found=discover_devices(5); my @rows; my $i=0; for my $d(@$found){ push @rows,{IDX=>$i,NAME=>$d->{alias},IP=>$d->{ip},MODEL=>$d->{model},CHECKED=>'checked'}; $i++; }
  start('Autodiscovery'); render('discover.html',{FOUND=>\@rows,HAS_FOUND=>@rows?1:0}); finish(); exit;
}
if($action eq 'import_discovery'){
  my $cfg=read_config(); my %known=map{$_->{ip}=>1}@{$cfg->{devices}}; for my $i($q->param('sel')){ my $ip=$q->param("d_ip_$i"); next if !$ip || $known{$ip}; my $name=$q->param("d_name_$i")||$ip; push @{$cfg->{devices}},{id=>sanitize_name($name),name=>$name,ip=>$ip,type=>'auto',enabled=>1}; }
  write_config($cfg); logmsg('OK','Discovered devices imported'); print $q->redirect('index.cgi?saved=1'); exit;
}
if($action eq 'loxone_vo_xml' || $action eq 'loxone_vi_xml'){
  my $cfg=read_config(); my $base=loxberry_base_url(); my $isvi=$action eq 'loxone_vi_xml';
  print $q->header(-type=>'application/xml',-charset=>'utf-8',-attachment=>$isvi?'VI_TP-Link_Plug_Control.xml':'VO_TP-Link_Plug_Control.xml');
  if(!$isvi){ print qq(<?xml version="1.0" encoding="utf-8"?>\n<VirtualOut HintText="" Title="TP-Link Plug Control" Comment="" Address=").xml_escape($base).qq(" CmdInit="" CloseAfterSend="true" CmdSep=";">\n\t<Info templateType="3" minVersion="17000331"/>\n); for my $d(@{$cfg->{devices}}){ next unless $d->{enabled}; my $ip=xml_escape($d->{ip}); print qq(\t<VirtualOutCmd Title=").xml_escape($d->{name}).qq(" Comment="" CmdOnMethod="GET" CmdOffMethod="GET" CmdOn="/admin/plugins/tplink/control.cgi?ip=$ip&amp;command=on" CmdOff="/admin/plugins/tplink/control.cgi?ip=$ip&amp;command=off" Analog="false"/>\n); } print "</VirtualOut>\n"; }
  else { print qq(<?xml version="1.0" encoding="utf-8"?>\n<VirtualInHttp Title="TP-Link Plug Control" Comment="" Address=").xml_escape($base).qq(/admin/plugins/tplink/status.cgi" HintText="" PollingTime="10">\n\t<Info templateType="2" minVersion="14070306"/>\n); for my $d(@{$cfg->{devices}}){ next unless $d->{enabled}; my $id=xml_escape($d->{id}); my $t=xml_escape($d->{name}); for my $k(qw(state online power voltage current energy)){ my $unit=$k eq 'power'?'W':$k eq 'voltage'?'V':$k eq 'current'?'A':$k eq 'energy'?'kWh':''; print qq(\t<VirtualInHttpCmd Title="$t $k" Comment="" Check="&quot;${id}_${k}&quot;:\\v" Signed="true" Analog="true" SourceValLow="0" DestValLow="0" SourceValHigh="100" DestValHigh="100" DefVal="0" MinVal="-10000" MaxVal="10000" Unit="$unit" HintText=""/>\n); } } print "</VirtualInHttp>\n"; }
  exit;
}
my $cfg=read_config(); my @rows; my $i=0; for my $d(@{$cfg->{devices}}){ push @rows,{IDX=>$i,NAME=>$d->{name},IP=>$d->{ip},TYPE=>$d->{type}||'auto',ENABLED_CHECKED=>$d->{enabled}?'checked':''}; $i++; }
start(); render('index.html',{DEVICES=>\@rows,NEW_IDX=>$i,LOGURL=>'/admin/system/tools/logfile.cgi?logfile=plugins/tplink/tplink.log&header=html&format=template',SAVED=>$q->param('saved')?1:0}); finish();
