#---+ Extensions
#---++ WhitelistAttachmentPlugin

# ---+++ General
# **STRING**
# A comma separated list of file extensions which are allowed in attachment filenames. Each entry can either include or omit the . (e.g. 'txt' and '.txt' are both equally valid). Regardless of this setting some extensions will always be permitted in order to retain standard wiki functionality (e.g. xml and svg). *Attention: If this is left empty then all extensions are automatically invalid.*
$Foswiki::cfg{Plugins}{WhitelistAttachmentPlugin}{AllowedExtensions} = '7z,accdb,ai,amsws,aqm,arr,asf,avery,avi,bab,bat,bmp,bpm,cae,catpart,cdr,cps,css,csv,dat,db,dbc,dia,doc,docm,docx,dot,dotm,dotx,dru,dwg,edrw,emf,eml,emlx,eps,exe,fig,fre,gan,gif,graffle,greenshot,h3d,hcp,hm,iam,ico,igx,indd,indt,java,jpeg,jpf,jpg,key,label,m,m4a,map,mat,mdb,mmap,mov,mp3,mp4,mpp,msg,odg,odp,ods,odt,oft,one,onetoc2,otf,ots,ott,ovpn,pdf,png,potm,potx,pps,ppsx,ppt,pptm,pptx,ps1,psd,pub,rar,rdp,rtf,shs,sql,story,swf,tif,tiff,ttf,txt,url,vcf,vsd,vsdx,webarchive,website,wmf,wmv,woff,xcf,xlam,xls,xlsb,xlsm,xlsx,xlt,xltm,xltx,xmind,xps,xrb,zip';
