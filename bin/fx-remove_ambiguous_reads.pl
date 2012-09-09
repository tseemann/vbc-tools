#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use VBC::Common;
use VBC::FastX;

while (my $seq = fastx_read(\*ARGV)) {
  next if $seq->[1] =~ m/[^agtc]/i;
  fastx_write(\*STDOUT, $seq);
}
