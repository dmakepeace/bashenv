#!/usr/bin/perl

use strict;

my $CRON_LOG='/var/log/cron';
my %hash_list;
open CRON, '<', $CRON_LOG;

while (<CRON>) {
	if (/^(?<date>\w+\s+\d+) (?:.*) (Skipping job run\.\))$/){
		if (!defined $hash_list{$+{date}}) {
			$hash_list{$+{date}}=1;
		}
		else { $hash_list{$+{date}} += 1; }
	}
}

foreach my $key (sort keys %hash_list) {
	printf "%s: %d\n", $key, $hash_list{$key};
}

close CRON;
