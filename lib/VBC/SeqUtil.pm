package VBC::SeqUtil;

use Exporter qw(import);

@EXPORT    = qw(slurp_fasta);
@EXPORT_OK = qw();

use strict;
use warnings;
use Bio::SeqIO;

#-------------------------------------------------------------------------
# Reads all sequences in a fasta file and returns them as:
#  - a list of Bio::Seq (in array context)
#  - a hashref of { display_id => Bio::Seq } (in scalar context)
#    if display_id is not unique only the last instance will be kept

sub slurp_fasta {
  my(@files) = @_;
  my %hash;
  my @list;
  for my $file (@files) {
    my $in = Bio::SeqIO->new(-file=>$file, -format=>'fasta');
    next unless $in;
    while (my $seq = $in->next_seq) {
      if (wantarray) {
        push @list, $seq;
      }
      else {
        $hash{ $seq->display_id } = $seq;
      }
    }
  }
  return wantarray ? @list : \%hash;
}
              
#-------------------------------------------------------------------------

1;
