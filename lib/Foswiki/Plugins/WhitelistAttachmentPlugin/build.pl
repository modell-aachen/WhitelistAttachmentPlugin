#!/usr/bin/env perl

BEGIN {
  unshift @INC, split(/:/, $ENV{FOSWIKI_LIBS});
}

use strict;
use warnings;
use Foswiki::Contrib::Build;

package WhitelistAttachmentBuild;
our @ISA = qw(Foswiki::Contrib::Build);

sub new {
  my $class = shift;
  return bless($class->SUPER::new("WhitelistAttachmentPlugin"), $class);
}

my $builder = WhitelistAttachmentBuild->new();
$builder->build($builder->{target});
