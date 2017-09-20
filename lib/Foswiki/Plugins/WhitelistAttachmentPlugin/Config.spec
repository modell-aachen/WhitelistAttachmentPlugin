#---+ Extensions
#---++ WhitelistAttachmentPlugin

# ---+++ General
# **STRING**
# A comma separated list of file extensions which are allowed in attachment filenames. Each entry can either include or omit the . (e.g. 'txt' and '.txt' are both equally valid). *Attention: If this is left empty then all extensions are automatically invalid.*
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = '';
