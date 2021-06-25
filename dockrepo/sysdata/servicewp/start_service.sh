#!/bin/bash
#                                                                    2020-02-01
#  Start PHP-based services
#
SERVICENAME='servicewp'#       <-- da domandare o come parametro di chiamata
HOME="/home/yesfi/"
WORKDIR=${HOME}"dockrepo/sysdata/servicewp/servicewpconfig/"
#
echo
echo
echo "---------------------------------------------------------"
echo "Use docker-compose to START the app ${SERVICENAME}"
echo
echo "Starting docker-compose ..."
cd ${WORKDIR}
docker-compose -f "${SERVICENAME}.yml" up -d
echo
echo "Running containers now are:"
~/showdock
echo
echo "Done."
