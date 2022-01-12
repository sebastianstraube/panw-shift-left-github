#!/bin/bash

curl -k -u $TL_USER:$TL_PASS --details --output ./twistcli https://$TL_CONSOLE/api/v1/util/twistcli
chmod a+x ./twistcli
 
docker pull pasqu4le/evilpetclinic:latest     
#curl -k -u $TL_USER:$TL_PASS --output ./twistcli https://$TL_CONSOLE/api/v1/util/twistcli
./twistcli images scan --u $TL_USER --p $TL_PASS --address https://$TL_CONSOLE --details pasqu4le/evilpetclinic -o output.json
result=$(curl -k -u $TL_USER:$TL_PASS -H 'Content-Type: application/json' "https://$TL_CONSOLE/api/v1/scans?type=ciImage&collections=evilpetclinic&reverse=true&sort=time&limit=1"|jq '.[0].vulnFailureSummary'|grep "Scan failed")

echo

if [ -z "$result" ] || [ $BYPASS_IMAGESCAN == 1 ]; then
   echo "Image Vulnerability scan passed!"
   exit 0
else
   echo "Image Vulnerability scan failed!"
   exit 1
fi

 
