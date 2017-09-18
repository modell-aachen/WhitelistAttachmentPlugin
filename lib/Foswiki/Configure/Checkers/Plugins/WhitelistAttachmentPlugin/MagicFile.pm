# See bottom of file for default license and copyright information
package Foswiki::Configure::Checkers::Plugins::WhitelistAttachmentPlugin::MagicFile;

use strict;
use warnings;

use Foswiki::Configure::Checker;
our @ISA = qw(Foswiki::Configure::Checker);

sub check_current_value {
  my ($this, $reporter) = @_;
  return unless defined $Foswiki::Plugins::SESSION;

  my $cfg = $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin};
  return unless $cfg->{Enabled};
  my $key = '{Plugins}{WhitelistAttachmentPlugin}{AdditionalMIMETypeChecking}';
  return unless $this->getCfg($key);
  return unless ($this->getCfg() =~ /^\s*$/ || ! -f $this->getCfg());

  $reporter->ERROR(<<"HERE");
In order to use MIME type checking you have to specify a valid magic file.
Usually such a file is located in you webserver's configuration directory.
E.g. '/etc/apache2/magic' or '/etc/httpd/conf/magic'.
HERE
}

1;

__END__
Q.wiki WhitelistAttachmentPlugin - Modell Aachen GmbH

Author: Sven Meyer <meyer@modell-aachen.de>

Copyright (C) 2017 Modell Aachen GmbH

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
