package VBC::Common;

use Exporter qw(import);

@EXPORT    = qw(inform problem run_cmd);
@EXPORT_OK = qw(exe_installed num_cpu temp_dir);

use strict;
use warnings;
use Time::Piece;
use File::Spec;
use File::Temp;

#-------------------------------------------------------------------------

sub inform {
  my @s = map { defined $_ ? $_ : '(undef)' } @_;
  my $t = localtime;
  print STDERR "[$t] ", @s, "\n";
}

#-------------------------------------------------------------------------

sub problem {
  inform @_;
  exit -1;
}

#-------------------------------------------------------------------------

sub exe_installed {
  my($bin) = shift;
  for my $dir (File::Spec->path) {
    my $exe = File::Spec->catfile($dir, $bin);
    return $exe if -x $exe; 
  }
  return;
}

#-------------------------------------------------------------------------

sub num_cpu {
  if ($^O =~ m/linux/i) {
    my($num) = qx(grep -c ^processor /proc/cpuinfo);
    chomp $num;
    return $num if defined $num and $num =~ m/^\d+$/;
  }
  elsif ($^O =~ m/darwin/i){
    my ($num) = qx(system_profiler SPHardwareDataType | grep Cores);
    $num =~ /.*Cores: (\d+)/;
    return $1 if defined $1 and $1 =~ m/^\d+$/;
  }
  return 1;
}

#-------------------------------------------------------------------------

sub temp_dir {
  return File::Temp->tempdir( CLEANUP=>1 );
}

#-------------------------------------------------------------------------

sub run_cmd {
  inform("Running: @_");
  if (system(@_)) {
    inform("ERROR $? : $!");
    exit $?;
  }
}
              
#-------------------------------------------------------------------------

1;
