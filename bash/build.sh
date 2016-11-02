echo "Fetching current date & time for ticket"

export DATE=`date +%Y-%m-%d:%H:%M:%S.000%z`
export RequiredStarttimetmp="$(sed '0,/RE/s/:/T/' <<<$DATE)"
export RequiredStarttime="$(sed 's/-/+/3' <<<$RequiredStarttimetmp)"

export Required_Start_Time=${RequiredStarttime}

echo ${Required_Start_Time}

date -d "+2 hours" +%Y-%m-%d:%H:%M:%S.000%z > expectedtime.txt
export ExpTime=$(< expectedtime.txt)
export TargetEndtimetmp="$(sed '0,/RE/s/:/T/' <<<$ExpTime)"
export TargetEndtime="$(sed 's/-/+/3' <<<$TargetEndtimetmp)"


export Target_End_Time=${TargetEndtime}

echo $Target_End_Time

echo "Changing values for new ticket"

rm -f jira-automation.json.bkp jira-automation.json.tmp1 jira-automation-json.tmp2 jira-automation-json.tmp3 
#mv jira-automation.json jira-automation.json.bkp 
cp jira-automation.json-body.txt jira-automation.json.tmp1 
sed -e "s/version-x.x.x.x/$Tobedeployed_Version/g" jira-automation.json.tmp1 >jira-automation.json.tmp2 
sed -e "22s/2014-06-07T17:29:29.908+0530/$Required_Start_Time/g" jira-automation.json.tmp2 >jira-automation.json.tmp3 
sed -e "23s/2014-06-07T19:00:00.000+0530/$Target_End_Time/g" jira-automation.json.tmp3 >jira-automation.json 