#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use VBC::Common;
use VBC::FastX;

while (my $seq = fastx_read(\*ARGV)) {
  $seq->[1] = lc $seq->[1];
  fastx_write(\*STDOUT, $seq);
}
