#!/bin/bash

FileName="sample.csv"
#ServerName="http://chexjvasec007.ch.expeso.com:54330/api/transaction/issueAwards"
ServerName="http://chelleolab003.karmalab.net:54330/api/transaction/issueAwards"
LogFileName="/home/sasetia/logs.txt"
IFS=","
while read tpid tuid orderNumber count
do
echo "TPID is : $tpid" >> $LogFileName
echo "TUID is : $tuid" >> $LogFileName
echo "OrderNumber is : $orderNumber" >> $LogFileName

curl -X POST  $ServerName -H 'Content-Type: application/xml' -H 'Accept: */*' --data-binary $'<?xml version="1.0" encoding="UTF-8"?>\n<sterling:IssueAwardsRequest xsi:schemaLocation="urn:expedia:e3:partnerlty:sterling:messages:v1 com.expedia.e3.partnerlty.sterling.messages.v1.xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:base="urn:expedia:e3:data:basetypes:defn:v4" xmlns:sterling="urn:expedia:e3:partnerlty:sterling:messages:v1" xmlns:types="urn:expedia:e3:partnerlty:sterling:types:v1">\n\x09<sterling:SterlingMessageInfo>\n\x09\x09<sterling:CallerApplicationName>String</sterling:CallerApplicationName>\n\x09\x09<sterling:MessageGUID>String</sterling:MessageGUID>\n\x09</sterling:SterlingMessageInfo>\n\x09<sterling:SiteIdentity>\n\x09\x09<base:SiteID>'$tpid'</base:SiteID>\n\x09</sterling:SiteIdentity>\n\x09<sterling:User>\n        <types:Tuid> \n          <types:tpid>'$tpid'</types:tpid>\n   <types:tuid>'$tuid'</types:tuid>\n        </types:Tuid>\n\x09\x09<!--<types:ExpUserId>1000000</types:ExpUserId>-->\n\x09</sterling:User>\n\x09<types:transactionHistoryMode>full</types:transactionHistoryMode>\n\x09<sterling:Component>\n \n<sterling:orderNumber>'$orderNumber'</sterling:orderNumber>\n \n\x09</sterling:Component>\n</sterling:IssueAwardsRequest>' --compressed >> LogFileName

echo `date` >> $LogFileName

done < $FileName
