#!/usr/bin/perl
use strict;use warnings;use CGI;use HTML::Template;use FindBin;
use lib "$FindBin::Bin/../../../../bin/plugins/tplink";use lib "/opt/loxberry/bin/plugins/tplink";
use tplink_lib qw(tplink_cmd paths get_lang logmsg);
my $q=CGI->new;my %p=paths();my $ip=$q->param('ip')||'';my $name=$q->param('name')||$ip;my $cmd=$q->param('command')||'';my $result='';
my $LBW=eval{require LoxBerry::Web; LoxBerry::Web->import(); 1}; my $LBS=eval{require LoxBerry::System; LoxBerry::System->import(); 1};
sub start { if($LBW){ LoxBerry::Web::lbheader('TP-Link Settings','',''); } else { print $q->header(-type=>'text/html',-charset=>'utf-8'); print '<html><body>'; } }
sub finish { if($LBW){ LoxBerry::Web::lbfooter(); } else { print '</body></html>'; } }
if($cmd eq 'settime'){ my($sec,$min,$hour,$mday,$mon,$year)=localtime; my($ok,$o,$raw)=tplink_cmd($ip,'settime',{year=>$year+1900,month=>$mon+1,mday=>$mday,hour=>$hour,min=>$min,sec=>$sec,index=>42},5); $result=$ok?'OK':$raw; logmsg($ok?'OK':'ERROR',"settings settime ip=$ip result=$result"); }
elsif($cmd eq 'reset' && (($q->param('confirm_reset')||'') ne 'YES')){ $result='Reset not executed'; logmsg('WARNING',"settings reset without confirmation ip=$ip"); }
elsif($cmd){ my($ok,$o,$raw)=tplink_cmd($ip,$cmd,undef,5); $result=($ok && $raw=~/err_code":0/)?'OK':$raw; logmsg($ok?'OK':'ERROR',"settings command=$cmd ip=$ip result=$result"); }
my($iok,$iobj,$iraw)=tplink_cmd($ip,'info',undef,3); my $si=$iok?($iobj->{system}{get_sysinfo}||{}):{};
my($tok,$tobj,$traw)=tplink_cmd($ip,'time',undef,3); my $th=$tok?($tobj->{time}{get_time}||{}):{}; my $date=''; if(defined $th->{year}){ $date=get_lang() eq 'en' ? sprintf('%04d-%02d-%02d %02d:%02d:%02d',$th->{year},$th->{month},$th->{mday},$th->{hour},$th->{min},$th->{sec}) : sprintf('%02d.%02d.%04d %02d:%02d:%02d',$th->{mday},$th->{month},$th->{year},$th->{hour},$th->{min},$th->{sec}); }
my $relay=defined $si->{relay_state}?$si->{relay_state}:0; my $led=defined $si->{led_off}?($si->{led_off}?0:1):0;
my @info=map{{KEY=>$_,VALUE=>$si->{$_}}} grep{defined $si->{$_}} qw(alias model mac sw_ver hw_ver relay_state led_off active_mode feature rssi on_time);
my($eok,$eobj,$eraw)=tplink_cmd($ip,'realtime',undef,3); my @energy; if($eok){ my $e=$eobj->{emeter}{get_realtime}||{}; @energy=map{{KEY=>$_,VALUE=>$e->{$_}}} sort keys %$e; }
start(); my $t=HTML::Template->new(filename=>"$p{templ}/settings.html",global_vars=>1,loop_context_vars=>1,die_on_bad_params=>0); eval{LoxBerry::System::readlanguage($t,'language.ini')} if $LBS;
$t->param(IP=>$ip,NAME=>$name,IS_ON=>$relay,LED_IS_ON=>$led,CONTROL_CMD=>$relay?'off':'on',LED_CMD=>$led?'led_off':'led_on',DATETIME=>$date,INFO=>\@info,HAS_ENERGY=>@energy?1:0,ENERGY=>\@energy,RESULT=>$result,HAS_RESULT=>$result?1:0);
print $t->output; finish();
