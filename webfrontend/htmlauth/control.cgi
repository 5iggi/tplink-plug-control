#!/usr/bin/perl
use strict;use warnings;use CGI;use FindBin;
use lib "$FindBin::Bin/../../../../bin/plugins/tplink";use lib "/opt/loxberry/bin/plugins/tplink";
use tplink_lib qw(read_config tplink_cmd extract_value sanitize_name logmsg);
my $q=CGI->new; print $q->header(-type=>'text/plain',-charset=>'utf-8');
my $ip=$q->param('ip')||''; my $dev=$q->param('device')||''; my $cmd=$q->param('command')||'';
if(!$ip && $dev){ my $cfg=read_config(); my $key=sanitize_name($dev); for(@{$cfg->{devices}}){ if(($_->{id}||'') eq $key){ $ip=$_->{ip}; last; } } }
if(!$ip || !$cmd){ print "Missing ip or command"; exit 1; }
my($ok,$obj,$raw)=tplink_cmd($ip,$cmd,undef,4); logmsg($ok?'INFO':'ERROR',"control ip=$ip command=$cmd result=".($ok?'ok':$raw));
if(!$ok){ print "ERROR: $raw"; exit 1; }
if($cmd=~/^(on|off|led_on|led_off|reboot|reset)$/){ print 'OK'; exit; }
if($cmd=~/^(state|power|voltage|current|energy)$/){ my $v=extract_value($cmd,$obj); print defined($v)?$v:'NA'; exit; }
print $raw;
