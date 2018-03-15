# FreeMobile.SendSMS
Envoi de SMS à votre compte freemobile depuis un PC

Developpement sous Harbour core V 3 (une evolution open source de Clipper 5) :

https://github.com/harbour/core#how-to-get

Telechargez la derniere version du compilateur Harbour ici (harbour-nightly-win.exe) :

https://sourceforge.net/projects/harbour-project/files/binaries-windows/nightly/

=> A installer dans un dossier racine \HB32 (C:\hb32 par exemple)

Pour Compiler vous-même :
Sous le dossier \HB32, creez un dossier FreeMobile,
Y Recopier l'ensemble des fichiers github.

Telechargez la derniere version de curl pour windows

https://github.com/vszakats/curl-for-win

Sur la page ci-dessous :

https://bintray.com/vszakats/generic/curl/7.59.0

=> Prendre la version du .ZIP suivante : curl-7.59.0-win32-mingw.zip

Dans le .ZIP, dossier lib, extraire les 2 librairies
libcurl.a et
libcurl.dll.a 

et les recopier dans le dossier \HB32\lib\win\mingw
Extraire aussi la DLL du dossier bin :
libcurl.dll

A recopier dans le dossier \HB32\FreeMobile
elle sert à l'executable final SendSms.exe

Pour compiler, dans le dossier FreeMobile, Tapez :
C SendSMS

=> Le fichier SendSMS.exe est alors créé.

Sinon, l'excutable opérationnel est fourni dans github

Usage de l'executable :

SendSMS "Message à transmettre"

Exemple : SendSMS "Ceci est un message d'essai"
-------------------------------------------------------------
