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

my $cfg;

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

  $cfg = $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin};
  $cfg->{Severity} ||= 'WARN';
  $cfg->{MIMETypeAssociation} ||= {};

  if ($cfg->{AdditionalMIMETypeChecking}) {
    eval {require File::MMagic;};
    if ($@) {
      Foswiki::Func::writeWarning("Unable to load 'File::Magic':", $@);
    }
  }

  return 1;
}

sub finishPlugin {
  undef $cfg;
}

# SMELL: deprecated handler
sub beforeAttachmentSaveHandler {
  my ($params, $topic, $web) = @_;

  # TODO: params->{name} wird in Meta::attach nicht übernommen...
  $_[0]->{name} = _sanitize($web, $topic, $params->{name})
    unless _validate($params->{name}, $params->{tmpFilename});
}

sub beforeCopyAttachmentHandler {
  my ($web, $topic, $attachment, $toWeb, $toTopic, $toAttachment) = @_;
  $_[5] = _sanitize($toWeb, $toTopic, $toAttachment)
    unless _validateCopyOrRename(@_);
}

sub beforeRenameAttachmentHandler {
  my ($web, $topic, $attachment, $toWeb, $toTopic, $toAttachment) = @_;
  $_[5] = _sanitize($toWeb, $toTopic, $toAttachment)
    unless _validateCopyOrRename(@_);
}

sub beforeUploadHandler {
  my ($params, $meta) = @_;

  # SMELL: '$params->{tmpFilename}' is only available because we've attached
  # a beforeAttachmentSaveHandler

  # TODO: params->{name} wird in Meta::attach nicht übernommen...
  $_[0]->{name} = _sanitize($meta->{_web}, $meta->{_topic}, $params->{name})
    unless _validate($params->{name}, $params->{tmpFilename});
}

sub _sanitize {
  my ($web, $topic, $attachment) = @_;

  if ($cfg->{Severity} eq 'WARN') {
    Foswiki::Func::writeWarning("Whitelist violation: $web.$topic.$attachment");
    return $attachment;
  } elsif($cfg->{Severity} eq 'RENAME') {
    $attachment =~ s/[\.\s]+$//g;
    return "$attachment." . ($cfg->{DisarmedExtension} || 'txt');
  } elsif ($cfg->{Severity} eq 'FAIL') {
    throw Foswiki::OopsException(
      'attention',
      def => "generic",
      web => $web,
      topic => $topic,
      keep => 1,
      params => [
        "Operation not permitted.",
        "Whitelist checks failed for attachment '$attachment'."
      ]
    );
  }
}

sub _validate {
  my ($filename, $filepath) = @_;

  my $allowed = _validateExtension($filename);
  return $allowed unless $cfg->{AdditionalMIMETypeChecking} || 0;
  return $allowed unless -f $cfg->{MagicFile};
  return _validateMIMEType($filename, $filepath);
}

sub _validateCopyOrRename {
  my ($web, $topic, $attachment, $toWeb, $toTopic, $toAttachment) = @_;

  my $path = File::Spec->catfile(
    $Foswiki::cfg{PubDir},
    $web,
    $topic,
    $attachment
  );

  return _validate($toAttachment, $path);
}

sub _validateExtension {
  my $filename = shift;

  my @exts = map {
    $_ =~ s/[\s\r\n\.]//gr
  } split(/,/, ($cfg->{AllowedExtensions} || ''));

  my $pattern = '(' . join('|', @exts) . ')$';
  return ($filename =~ /$pattern/) || 0;
}

sub _validateMIMEType {
  my ($filename, $filepath) = @_;

  my $mm = new File::MMagic->($cfg->{MagicFile});
  my $type = checktype_filename($filepath);
  my $ext = pop(@{split('.', $filename)});

  return 0 unless defined $cfg->{MIMETypeAssociation}{$ext};
  return 0 unless $cfg->{MIMETypeAssociation}{$ext} eq $type;
  return 1;
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
