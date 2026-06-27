#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use JSON qw(encode_json);
use FindBin;
use lib "$FindBin::Bin/../../../../bin/plugins/tplink";
use lib "/opt/loxberry/bin/plugins/tplink";
use tplink_lib qw(read_config tplink_cmd extract_value sanitize_name logmsg);

my $q = CGI->new;
print $q->header(-type => 'application/json', -charset => 'utf-8');

my $cfg = read_config();
my %out;

for my $d (@{$cfg->{devices}}) {
    next unless $d->{enabled};

    my $id = $d->{id} || sanitize_name($d->{name});
    my ($ok, $obj, $raw) = tplink_cmd($d->{ip}, 'info', undef, 2);

    $out{"${id}_online"} = $ok ? 1 : 0;
    $out{"${id}_state"}  = $ok ? extract_value('state', $obj) : 0;

    my ($eok, $eobj, $eraw) = tplink_cmd($d->{ip}, 'realtime', undef, 2);
    for my $k (qw(power voltage current energy)) {
        my $v = $eok ? extract_value($k, $eobj) : 0;
        $out{"${id}_${k}"} = defined($v) ? $v : 0;
    }
}

# Important: Do not write an INFO log line on every status.cgi call.
# Loxone may poll this endpoint every few seconds. Excessive log growth can trigger
# LoxBerry log maintenance on the RAM disk and make the visible log disappear.
print encode_json(\%out);
