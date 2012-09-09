package VBC::FastX;

use strict;
use warnings;

our(@EXPORT, @EXPORT_OK);
BEGIN {
  use base qw(Exporter);
  @EXPORT    = qw(
    fastx_read fastx_write fastx_revcom
    fastq_read fastq_write
    fasta_read fasta_write
  );
  @EXPORT_OK = qw();
}

use Data::Dumper;

#-------------------------------------------------------------------------
# return tuple fastq=[ID,seq,qual]  fasta=[ID,seq]

sub fastx_read {
  my($fh) = @_;
  my @s;
  $s[0] = <$fh>;
  return if not defined $s[0];
  # FASTQ
  if (substr($s[0], 0, 1) eq '@') {
    $s[1] = <$fh>;
    scalar(<$fh>);
    $s[2] = <$fh>;
  }
  # FASTA
  elsif (substr($s[0], 0, 1) eq '>') {
    $s[1] = <$fh>;
  }
  # ERROR
  else {
    return; 
  }
  chomp @s;
  return \@s;
}

#-------------------------------------------------------------------------

sub fastx_write {
  my($fh, $s) = @_;
  if (@$s == 2) {
    print $fh "$s->[0]\n$s->[1]\n";
  }
  elsif (@$s == 3) {
    print $fh "$s->[0]\n$s->[1]\n+\n$s->[2]\n";
  }
}

#-------------------------------------------------------------------------

sub fastx_revcom {
  my($s) = @_;
  # 0=id, 1=seq, 2=qual
  $s->[1] = reverse $s->[1];
  $s->[1] =~ tr/ATGCatgc/TACGtacg/;
  $s->[2] = reverse $s->[2] if $s->[2];
  return $s;
}

#-------------------------------------------------------------------------

sub fastq_read {
  my($fh) = @_;
  my @s = map { scalar(<$fh>) } 1..4;   # read 4 lines
  chomp(@s);                            # remove \n from ends
  $s[0] = substr($s[0], 1);             # remove @ from ID
  splice @s,2,1;                        # remove 3rd line
  return \@s;                           # return 3-tuple [ ID,seq,qual ]
}

#-------------------------------------------------------------------------

sub fasta_read {
  my($fh) = @_;
  my @s = map { scalar(<$fh>) } 1..2;   # read 2 lines
  chomp(@s);                            # remove \n from ends
  $s[0] = substr($s[0], 1);             # remove > from ID
  return \@s;                           # return 3-tuple [ ID,seq,qual ]
}

#-------------------------------------------------------------------------

sub fastq_write {
  my($fh, $s) = @_;
  my $qval = (@$s == 3) ? $s->[2] : 'H'x(length($s->[1]));
  print $fh '@',$s->[0],"\n",$s->[1],"\n+\n",$qval,"\n";
}

#-------------------------------------------------------------------------

sub fasta_write {
  my($fh,$s) = @_;
  print $fh '>',$s->[0],"\n",$s->[1],"\n";
}

#-------------------------------------------------------------------------

1;
