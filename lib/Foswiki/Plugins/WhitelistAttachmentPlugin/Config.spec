#---+ Extensions
#---++ WhitelistAttachmentPlugin

# ---+++ General
# **SELECT FAIL,RENAME,WARN LABEL="Severity"**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{Severity} = 'WARN';

# **STRING EXPERT LABEL="Extension to attach if {Severity} is set to RENAME"**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{DisarmedExtension} = 'txt';

# ---+++ Plugin Handlers
# **BOOLEAN LABEL="Enable handler: beforeCopyAttachment"**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{BeforeCopyAttachmentHandler} = 1;

# **BOOLEAN LABEL="Enable handler: beforeRenameAttachment"**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{BeforeRenameAttachmentHandler} = 1;

# ---+++ Whitelist
# **STRING**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = '';

# **BOOLEAN EXPERT**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AdditionalMIMETypeChecking} = 0;

# **STRING CHECK_ON_CHANGE="{Plugins}{WhitelistAttachmentPlugin}{AdditionalMIMETypeChecking}" EXPERT**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{MagicFile} = '';

# **PERL EXPERT**
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{MIMETypeAssociation} = {};
