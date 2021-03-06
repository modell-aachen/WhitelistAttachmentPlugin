# See bottom of file for default license and copyright information
package Foswiki::Plugins::WhitelistAttachmentPlugin::Meta;

use strict;
use warnings;

use Foswiki::Func;
use Foswiki::Meta;
use Foswiki::Plugin;

my $attach;
my $copyAttachment;
my $moveAttachment;
my $hooked;

my %handlers = (
  attach => 'beforeAttachHandler',
  copy => 'beforeCopyAttachmentHandler',
  move => 'beforeRenameAttachmentHandler',
);

sub hook {
  return if defined $hooked;

  _hookBeforeAttach();
  _hookBeforeCopy();
  _hookBeforeRename();

  $hooked = 1;
  return undef;
}

sub attach {
  return _invokeAttachHandler('attach', \&$attach, @_);
}

sub copy {
  return _invokeRenameCopyHandler('copy', \&$copyAttachment, @_);
}

sub move {
  return _invokeRenameCopyHandler('move', \&$moveAttachment, @_);
}

sub _hookBeforeAttach {
  $attach = \&Foswiki::Meta::attach;
  undef *Foswiki::Meta::attach;
  *Foswiki::Meta::attach =
      \&Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::attach;
  push @{Foswiki::Plugin::registrableHandlers}, $handlers{attach};
}

sub _hookBeforeCopy {
  $copyAttachment = \&Foswiki::Meta::copyAttachment;
  undef *Foswiki::Meta::copyAttachment;
  *Foswiki::Meta::copyAttachment =
      \&Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::copy;
  push @{Foswiki::Plugin::registrableHandlers}, $handlers{copy};
}

sub _hookBeforeRename {
  $moveAttachment = \&Foswiki::Meta::moveAttachment;
  undef *Foswiki::Meta::moveAttachment;
  *Foswiki::Meta::moveAttachment =
      \&Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::move;
  push @{Foswiki::Plugin::registrableHandlers}, $handlers{move};
}

sub _invokeRenameCopyHandler {
  my ($handler, $func, $meta, $from_attachment, $to, %opts) = @_;

  my ($from_web, $from_topic) = ($meta->{_web}, $meta->{_topic});
  my ($to_web, $to_topic) = ($to->{_web}, $to->{_topic});
  my $to_attachment = $opts{new_name} || $from_attachment;

  ($to_web, $to_topic, $to_attachment) =
    _validateWTA($to_web, $to_topic, $to_attachment);

  $Foswiki::Plugins::SESSION->{plugins}->dispatch(
    $handlers{$handler},
    $from_web, $from_topic, $from_attachment,
    $to_web, $to_topic, $to_attachment,
    \%opts
  );

  $opts{new_name} = $to_attachment;
  return $func->($meta, $from_attachment, $to, %opts);
}

sub _invokeAttachHandler {
  my ($handler, $func, $meta, %opts) = @_;

  $Foswiki::Plugins::SESSION->{plugins}->dispatch(
    $handlers{$handler},
    $meta->web(),
    $meta->topic(),
    $opts{name},
    \%opts
  );

  return $func->($meta, %opts);
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
