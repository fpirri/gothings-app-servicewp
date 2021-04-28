#!/bin/bash
#
#  script: set up .../nginxdata/sites-enabled/
#
##########################################################################
#
# ----------------------------------
# Define filenames
AppName="servicewp"
UserName=yesfi
HomeDir="/home/${UserName}/"
Dockrepo="${HomeDir}dockrepo/"
AppDir="${Dockrepo}sysdata/${AppName}/"
SiteFile="${AppDir}nginxdata/sites-enabled/${AppName}"
SiteNginxDir="${Dockrepo}sysdata/nginxdata/sites-enabled/"
# ----------------------------------
# costanti varie
Red='\033[0;41;30m'
Std='\033[0;0;39m'
#
##########################################################################
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
#
echo "Script: $0"
echo
echo "--------------------------------------------------"
echo "    setup nginxdata/sites-enabled"
echo "      <-- copy server definition for ${AppName}"
echo
sudo cp "${SiteFile}" "${SiteNginxDir}"
RetValue=$?
if [ "${RetValue}" -eq 0 ]; then
  echo "Successfully copied file"
  echo -e "${Red} verifica nginx status: not implemented yet for ${AppName} ${Std}"
  pause 
sudo 
else
  echo -e "${Red} Could not create sites-enabled file for ${AppName} ${Std}"
  RetValue=66
  dots 3
  exit ${RetValue}
fi
exit ${RetValue}