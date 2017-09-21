#---+ Extensions
#---++ WhitelistAttachmentPlugin

# ---+++ General
# **STRING**
# A comma separated list of file extensions which are allowed in attachment filenames. Each entry can either include or omit the . (e.g. 'txt' and '.txt' are both equally valid). Regardless of this setting some extensions will always be permitted in order to retain standard wiki functionality (e.g. xml and svg). *Attention: If this is left empty then all extensions are automatically invalid.*
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = '';
