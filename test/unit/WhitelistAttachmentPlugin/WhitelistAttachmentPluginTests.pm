package WhitelistAttachmentPluginTests;

use strict;
use warnings;

use ModacUnitTestCase;
our @ISA = qw( ModacUnitTestCase );

use Error qw ( :try );
use Foswiki::Plugins::WhitelistAttachmentPlugin;

sub new {
    my ($class, @args) = @_;
    my $this = shift()->SUPER::new('WhitelistAttachmentPluginTests', @args);
    return $this;
}

sub loadExtraConfig {
    my $this = shift;
    $this->SUPER::loadExtraConfig();
    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{Enabled} = 1;
    return;
}

sub set_up {
    my $this = shift;

    $this->SUPER::set_up();
    return;
}

sub tear_down {
    my $this = shift;

    $this->SUPER::tear_down();
    return;
}

sub test_isValidExtensionReturnsTrueForValidExtensions {
    my ( $this ) = @_;

    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = 'txt';

    $this->assert(Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension('Test.txt'), "Valid extension was not accepted.");
    return;
}

sub test_isValidExtensionReturnsFalseForInvalidExtensions {
    my ( $this ) = @_;

    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = 'txt';

    $this->assert(!Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension('Test.html'), "Invalid extension was accepted.");
    return;
}

sub test_isValidExtensionReturnsFalseForFileNamesWithoutExtension {
    my ( $this ) = @_;

    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = 'txt';

    $this->assert(!Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension('Test'), "Filename without extension was accepted.");
    return;
}

sub test_isValidExtensionReturnsFalseIfAllowedExtensionsConfigIsEmpty {
    my ( $this ) = @_;

    $Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = '';

    $this->assert(!Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension('Test'), "Extension was accepted although no extensions are allowed.");
    $this->assert(!Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension('Test.txt'), "Extension was accepted although no extensions are allowed.");
    return;
}

sub test_beforeCopyAttachmentHandlerShowsErrorPageOnInvalidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 0;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeCopyAttachmentHandler();


    $this->assert($errorPageShown, "No error page has been shown although the extension is invalid");
    return;
}

sub test_beforeCopyAttachmentHandlerShowsNoErrorPageOnValidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 1;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeCopyAttachmentHandler();


    $this->assert(!$errorPageShown, "Error page has been shown although the extension is valid");
    return;
}

sub test_beforeRenameAttachmentHandlerShowsErrorPageOnInvalidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 0;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeRenameAttachmentHandler();


    $this->assert($errorPageShown, "No error page has been shown although the extension is invalid");
    return;
}

sub test_beforeRenameAttachmentHandlerShowsNoErrorPageOnValidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 1;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeRenameAttachmentHandler();


    $this->assert(!$errorPageShown, "Error page has been shown although the extension is valid");
    return;
}

sub test_beforeUploadHandlerShowsErrorPageOnInvalidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 0;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    my $mockMeta = Foswiki::Meta->new($Foswiki::Plugins::SESSION, "Web", "Topic");
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeUploadHandler({}, $mockMeta);


    $this->assert($errorPageShown, "No error page has been shown although the extension is invalid");
    return;
}

sub test_beforeUploadHandlerShowsNoErrorPageOnValidExtension {
    my ( $this ) = @_;

    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_isValidExtension", sub {
        return 1;
    });

    my $errorPageShown = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage", sub {
        $errorPageShown = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::beforeUploadHandler();


    $this->assert(!$errorPageShown, "Error page has been shown although the extension is valid");
    return;
}

sub test_showErrorPageThrowsAnException {
    my ( $this ) = @_;

    my $exceptionThrown = 0;
    try {
        Foswiki::Plugins::WhitelistAttachmentPlugin::_showErrorPage("web", "topic", "attachment");
    } catch Foswiki::OopsException with {
        $exceptionThrown = 1;
    };


    $this->assert($exceptionThrown, "showErrorPage did not throw an exception.");
    return;
}

sub test_earlyInitFunctionInstallsMetaHooks {
    my ( $this ) = @_;

    my $hookInstalled = 0;
    $this->mock("Foswiki::Plugins::WhitelistAttachmentPlugin::Meta::hook", sub {
        $hookInstalled = 1;
        return;
    });
    Foswiki::Plugins::WhitelistAttachmentPlugin::earlyInitPlugin();


    $this->assert($hookInstalled, "The plugin did not install meta hooks.");
    return;
}

1;
__END__
Foswiki - The Free and Open Source Wiki, http://foswiki.org/

Author: Modell Aachen GmbH

Copyright (C) 2008-2011 Foswiki Contributors. Foswiki Contributors
are listed in the AUTHORS file in the root of this distribution.
NOTE: Please extend that file, not this notice.

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
