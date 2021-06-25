#!/bin/bash
#
                                                                                   VERSION="0.01.00"
#######
#
#  AZZERAMENTO completo di una installazione wordpress
#
########
#
#  Usato per costruire un generico container wordpress
#    - Nota: versione precedente usata da gocloud-wp
#        <-- in questo caso NON si esegue un backup del db
#
#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress nel database
#  - si usa la configurazione in .../<service>/.env-<service>
#
############################################################################
#                                                             ANCORA DA FARE
#  per il file <service>.yml :
#    scrittura automatica del file.yml
#  post-configurazione del contenuto di var_www_<SERVICE.NAME>
#     
#  configurazione automatica con richiesta del nome del servizio ...
#  eventualment, file json per la configurazione
#  scelta conf bash/json
#
############################################################################
#
ROOTPWD="GTH2020_quattro_marzo"#--- messo qui per non legare la db rootpwd a .env*
#
# leggi i dati di configurazione per questa app
. SERVICENAME
#
# Variabili utili
COMMAND=""
#
# costanti
RED='\033[0;41;30m'
STD='\033[0;0;39m'
HOME="/home/yesfi/"
WORKDIR=${HOME}dockrepo/sysdata/${SERVICENAME}/
SERVICEDIR==${WORKDIR}${SERVICENAME}/servicewpconfig/"
#
##
##########################################################################
#
avanti(){
  # Domanda di continuazione personalizzabile
  # call:    avanti $1
  #   $1:    "<stringa di domanda>"
  echo "----------------------------------------------------------------"
  read -rsp "$1" -n 1 key
  echo
}
#
##########################################################################
pause() {
#  Domanda 'continue or exit'
  avanti 'Press any key to continue or ^C to exit ...'
}
#
##########################################################################
dots(){
  # wait $1 seconds, printing dots on the screen
  #   $1 :  # of seconds to wait
  local param1
  printf -v param1 '%d\n' $1 2>/dev/null # converti in intero con tutti i controlli
  while [ $param1 -gt 0 ]
  do
    echo -n "."
    sleep 0.5
    echo -n "."
    sleep 0.5
    let "--param1"
  done
}
#
##########################################################################
# make a copy of db
#** Not used in this version                        *** to be modified ***
backupdb(){
#
#//  https://www.matteomattei.com/how-to-clone-mysql-database-schema-in-php/
#//    <--  usata com template ..
#//    <--  problemi con l'utente wpuser su gtlite_bk
#//         <-- utente root remoto non ha GRANT
#//    <--  versione cli: thanks to Richard Maurer
#
  curl --verbose 'http://www.gothings.org/go_creadb_bk.php'
#  - si esegue una copia del db gtlite su gtlite_bk

  echo "backup db DA FARE !"
}
#
##########################################################################
delwpfiles(){
#
# Lasciato quasi inalterato dalla versione precedente                  CAMBIARE?
#
#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress in gtlite
#  - si rileggono i file di configurazione wpinit.json e wpinstall.json da github
#      <-- per il momento NON si legge wpexpand.json per non usare wpdirs.tar.gz
#          in fase di sviluppo

#  - si eliminano TUTTI i file generati da wordpress
#      <-- files di nome wp-*
#      <-- altri files: index.php, license.txt, xmlrpc.php, readme.html, .htaccess
#      <-- dirs: wp-admin, wp-includes, wp-content
#  - si eliminano TUTTE le tabelle wordpress in gtlite
#  - si rileggono i file di configurazione wpinit.json e wpinstall.json da github
#      <-- per il momento NON si legge wpexpand.json per non usare wpdirs.tar.gz
#          in fase di sviluppo

echo
echo "     <-- delete wordpress dirs"
echo "     <-- wp-admin"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-admin
echo "     <-- wp-includes"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-includes
echo "     <-- wp-content"
sudo rm -rf dockrepo/sysdata/var_www/html/wp-content
echo
echo "     <-- delete wordpress files"
sudo rm -rf index.php license.txt xmlrpc.php readme.html .htaccess
#
#
#
#######
# Rimangono:   ??                                                     ELIMINARE?
}
#
##########################################################################
#                                                         CLEAR OPERATIONS
echo
echo
echo "--------------------------------------------------------- wpclear v$VERSION"
echo
echo "          Wordpress CLEAR function"
echo "This function will COMPLETELY REMOVE wordpress from"
echo "database and will delete ALL wordpress files"
echo
echo -e "  ${RED}  This operation in NOT RECOVERABLE !!!   ${STD}"
echo -e "  ${RED}                                          ${STD}"
echo
echo "-----------------------------------------------------------------------"
echo
echo "Please note:"
echo "this is your last chance NOT to DESTROY your ${SERVICEDISPLAYNAME} installation!"
echo
echo "Please note also: I will ask for your sudo password"
read -rsp "Do you like to CLEAR ? [y/N] " -n 1 key
case "$key" in
  [yY]) 
      # backupdb   <-- al momento, non previsto
      # eseguire il delete!
      if delwpfiles then
        echo 
        echo "DELETE Files OK"
        echo
        if deletedb then
          echo 
          echo "DELETE db tables OK"
          echo
        else
          echo 
          echo "DELETE db tables  operation GOT ERRORS"
          echo
        fi
      else
        echo
        echo
        echo "DELETE service operation GOT ERRORS"
        dots 2
      fi
      ;;
    *)
      echo
      echo
      echo "DELETE service operation NOT performed"
      dots 2
      RETVALUE=0
      ;;
esac
#
#############################################################################