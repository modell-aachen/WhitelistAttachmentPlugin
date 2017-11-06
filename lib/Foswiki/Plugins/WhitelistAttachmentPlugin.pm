# See bottom of file for default license and copyright information
package Foswiki::Plugins::WhitelistAttachmentPlugin;

use strict;
use warnings;

use File::Spec;
use Foswiki::Func;
use Foswiki::OopsException;
use Foswiki::Plugins;
use Foswiki::Plugins::WhitelistAttachmentPlugin::Meta;


our $RELEASE = '1.0.0';
our $VERSION = '1.0.0';

our $NO_PREFS_IN_TOPIC = 1;
our $SHORTDESCRIPTION = <<DESC;
This plugins allows to whitelist a given set of attachment types which are
allowed to be uploaded.'
DESC

our @ALWAYS_ALLOWED_EXTENSIONS = ("xml", "svg");

sub earlyInitPlugin {
    return unless $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{Enabled};
    return Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::hook();
}

sub initPlugin {
  my ($topic, $web, $user, $installWeb) = @_;
  if ($Foswiki::Plugins::VERSION < 2.0) {
    Foswiki::Func::writeWarning('Version mismatch between ',
    __PACKAGE__, ' and Plugins.pm');
    return 0;
  }

  return 1;
}

sub beforeAttachHandler {
  my ($web, $topic, $attachmentName) = @_;
  if(!_isValidExtension($attachmentName)){
    _showErrorPage($web, $topic, $attachmentName);
  }
  return;
}

sub beforeCopyAttachmentHandler {
  my ($web, $topic, $attachment, $toWeb, $toTopic, $toAttachment) = @_;
  if(!_isValidExtension($toAttachment)){
    _showErrorPage($web, $topic, $toAttachment);
  }
  return;
}

sub beforeRenameAttachmentHandler {
  my ($web, $topic, $attachment, $toWeb, $toTopic, $toAttachment) = @_;
  if(!_isValidExtension($toAttachment)){
    _showErrorPage($web, $topic, $toAttachment);
  }
  return;
}

sub _showErrorPage {
  my ($web, $topic, $attachment) = @_;

    my $session = $Foswiki::Plugins::SESSION;
    throw Foswiki::OopsException(
      'generic',
      web => $web,
      topic => $topic,
      keep => 1,
      params => [
        $session->i18n->maketext("Attachment operation not permitted"),
        $session->i18n->maketext("The file extension violates the security settings"),
        "'$attachment'"
      ]
    );
}

sub _isValidExtension {
  my $filename = shift;

  my $allowedExtensions = $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions};

  my @exts = map {
    $_ =~ s/[\s\r\n\.]//gr
  } split(/,/, ($allowedExtensions));

  @exts = (@exts, @ALWAYS_ALLOWED_EXTENSIONS);

  my $pattern = '(' . join('|', @exts) . ')$';
  return ($filename =~ /$pattern/i) || 0;
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
