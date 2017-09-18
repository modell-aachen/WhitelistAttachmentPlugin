# See bottom of file for default license and copyright information
package Foswiki::Plugins::WhitelistAttachmentPlugin::Meta;

use strict;
use warnings;

use Foswiki::Func;
use Foswiki::Meta;
use Foswiki::Plugin;

my $copyAttachment;
my $moveAttachment;
my $hooked;

my %handlers = (
  copy => 'beforeCopyAttachmentHandler',
  move => 'beforeRenameAttachmentHandler',
);

sub hook {
  return if defined $hooked;

  _hookBeforeCopy();
  _hookBeforeRename();

  $hooked = 1;
  return undef;
}

sub copy {
  return _invokeHandler('copy', \&$copyAttachment, @_);
}

sub move {
  return _invokeHandler('move', \&$moveAttachment, @_);
}

sub _hookBeforeCopy {
  return unless _useHandler($handlers{copy});

  $copyAttachment = \&Foswiki::Meta::copyAttachment;
  undef *Foswiki::Meta::copyAttachment;
  *Foswiki::Meta::copyAttachment =
      \&Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::copy;
  push @{Foswiki::Plugin::registrableHandlers}, $handlers{copy};
}

sub _hookBeforeRename {
  return unless _useHandler($handlers{move});

  $moveAttachment = \&Foswiki::Meta::moveAttachment;
  undef *Foswiki::Meta::moveAttachment;
  *Foswiki::Meta::moveAttachment =
      \&Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::move;
  push @{Foswiki::Plugin::registrableHandlers}, $handlers{move};
}

sub _invokeHandler {
  my ($handler, $func, $meta, $from_attachment, $to, %opts) = @_;

  my ($from_web, $from_topic) = ($meta->{_web}, $meta->{_topic});
  my ($to_web, $to_topic) = ($to->{_web}, $to->{_topic});
  my $to_attachment = $opts{new_name} || $from_attachment;

  ($to_web, $to_topic, $to_attachment) =
    _validateWTA($to_web, $to_topic, $to_attachment);

  $meta->{_session}->{plugins}->dispatch(
    $handlers{$handler},
    $from_web, $from_topic, $from_attachment,
    $to_web, $to_topic, $to_attachment
  );

  $opts{new_name} = $to_attachment;
  return $func->($meta, $from_attachment, $to, %opts);
}

sub _useHandler {
  my $handler = shift;

  my $useHandler =
    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{ucfirst($handler)};
  return defined $useHandler ? $useHandler : 1;
}

sub _validateWTA {
  my ($web, $topic, $attachment) = @_;

  # SMELL: access to undocumented, private method
  # We call _validateWTA here since it's possible a Plugin moved an attachment
  # by using the Meta API directly instead of invoking
  # Foswiki::Func::moveAttachment.
  return Foswiki::Func::_validateWTA($web, $topic, $attachment);
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
