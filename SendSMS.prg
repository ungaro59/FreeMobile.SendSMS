#require "hbcurl"
#include "fileio.ch"

#define VRAI 1
#define FAUX 0

FUNCTION Main()

   LOCAL MON_NUMERO_CLIENT, MA_CLE_D_IDENTIFICATION
   LOCAL Resultat := 0, sMessage_a_envoyer, url, sMessage_a_encoder

   SET DATE french
   hb_cdpSelect( "UTF8" ) // Pour obtenir les caracteres accentués

   // Parametre pour le montant minimum des soldes à selectionner
   IF PCount() == 1
      sMessage_a_encoder = hb_PValue( 1 )
   ELSE
      ?"SendSMS, Envoi d'un Sms à votre numéro de mobile FreeMobile"
      ?"Avant d'utiliser ce programme, modifiez le fichier 'PARAMETRES.INI'"
      ?"avec vos identifiants FreeMobile"
      ?"Encodage du message à la norme RFC3986 : https://tools.ietf.org/html/rfc3986"
      ?
      ?"Syntaxe : SendSMS " + Chr( 34 ) + "Message" + Chr( 34 )
      ?
      ?"Codes retour Possibles : "
      ?"200 => Le SMS a été envoyé sur votre mobile"
      ?"400 => Un des paramètres obligatoires est manquant ou erroné"
      ?"402 => Trop de SMS ont été envoyés en trop peu de temps"
      ?"403 => Le service n’est pas activé sur l’espace abonné, ou login/clé incorrect"
      ?"500 => Erreur côté serveur. Veuillez réessayez ultérieurement."
      ?
      ?
      QUIT
   ENDIF

   MON_NUMERO_CLIENT = iniLIT( "PARAMETRES", "MON_NUMERO_CLIENT", "", "parametres.ini" )
   MA_CLE_D_IDENTIFICATION = iniLIT( "PARAMETRES", "MA_CLE_D_IDENTIFICATION", "", "parametres.ini" )

   ?"N° de Client         : " + MON_NUMERO_CLIENT
   ?"Clé d'identification : " + MA_CLE_D_IDENTIFICATION
   ?"Message              : " + smessage_a_encoder
   ?

   url = "https://smsapi.free-mobile.fr/sendmsg?user=" + MON_NUMERO_CLIENT + "&pass=" + MA_CLE_D_IDENTIFICATION + "&msg="
   Resultat = lance_url( URL, smessage_a_encoder )

   DO CASE
   CASE resultat = 200
      ?"<200> Le SMS a été envoyé sur votre mobile"
   CASE resultat = 400
      ?"<400> Un des paramètres obligatoires est manquant ou erroné"
   CASE resultat = 402
      ?"<402> Trop de SMS ont été envoyés en trop peu de temps"
   CASE resultat = 403
      ?"<403> Le service n’est pas activé sur l’espace abonné, ou login/clé incorrect"
   CASE resultat = 500
      ?"<500> Erreur côté serveur. Veuillez réessayez ultérieurement."
   OTHERWISE
      ?"Erreur code : " + Str( resultat, 4 )
   ENDCASE

   ?
   ?

   curl_global_cleanup()

   RETURN resultat


FUNCTION iniLIT( section, mot_cle, non_trouve, fichier )

   LOCAL hIni, aSect, cvalue

   IF Empty( hIni := hb_iniRead( fichier ) )
      ? "Le fichier " + fichier + " n'existe pas ou n'a pas un format correct pour un .INI"
      RETURN ""
   ENDIF
   FOR EACH aSect IN hIni
      IF  Upper( aSect:__enumKey() ) = Upper( section )
         FOR EACH cValue IN aSect
            IF Upper( cValue:__enumKey() ) = Upper( mot_cle )
               RETURN cValue
            ENDIF
         NEXT
      ENDIF
   NEXT

   RETURN ""


FUNCTION lance_url( sURL,message_a_encoder )

   LOCAL cFolderDestino := "." // StrCapFirst( cFilePath( GetModuleFileName( GetInstance() ) ) + "Descargas" )
   LOCAL curl, lOK, UrlOK

   curl_global_init()

   IF ! Empty( curl := curl_easy_init() )
      UrlOK = sURL + curl_easy_escape( curl, message_a_encoder, Len( message_a_encoder ) )
      // curl_easy_setopt( curl, HB_CURLOPT_DOWNLOAD )
      curl_easy_setopt( curl, HB_CURLOPT_URL, UrlOK )
      // Si usa https, estas lineas ayudan
      curl_easy_setopt( curl, HB_CURLOPT_SSL_VERIFYPEER, FAUX )
      curl_easy_setopt( curl, HB_CURLOPT_SSL_VERIFYHOST, FAUX )
      curl_easy_setopt( curl, HB_CURLOPT_FOLLOWLOCATION )        // Necesario para aquellos sitios que nos redirigen a otros
      curl_easy_setopt( curl, HB_CURLOPT_FILETIME, 1 )
      // curl_easy_setopt( curl, HB_CURLOPT_DL_FILE_SETUP,cFolderDestino + "\recup.htm")
      curl_easy_setopt( curl, HB_CURLOPT_NOPROGRESS, VRAI )
      curl_easy_setopt( curl, HB_CURLOPT_VERBOSE, FAUX )

      IF curl_easy_perform( curl ) == 0
         lOK := curl_easy_getinfo( curl, HB_CURLINFO_RESPONSE_CODE )
      ELSE
         lOK := curl_easy_getinfo( curl, HB_CURLINFO_RESPONSE_CODE )
      ENDIF
      curl_easy_reset( curl )
   ENDIF
   curl_global_cleanup()

   RETURN lOK
