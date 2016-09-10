#!/bin/bash
# 1st argument must be the DC to query
# 2nd arg - username to query
# 2016 - RaddKat <RaddKatt0@gmail.com>

if [ "$#" -ne 2 ]; then
	echo
	echo "Usage: ./ad.sh <domain> <username>"
	echo " -- <domain> = domain name to query"
	echo " -- <username> = the username to query"
	echo "Example: '$ ./ad.sh subdomain.domain.com myuser'"
	echo

else

	DOMAINCOUNT=$(grep -o "\." <<< "$1" | wc -l)

	DC1=$(echo $1 | cut -f1 -d .)
	DC2=$(echo $1 | cut -f2 -d .)
	DC3=$(echo $1 | cut -f3 -d .)
	OUTPUT="$(ldapsearch -LLL -o ldif-wrap=no -h $1 -b "dc=$DC1,dc=$DC2,dc=$DC3" "(samaccountname=$2)" cn displayName userAccountControl sAMAccountName mail department company manager lastLogonTimestamp badPwdCount pwdLastSet accountExpires lockoutTime l st co extensionAttribute1 2> /dev/null)"

	echo
	echo "$OUTPUT" | grep "^dn:" | sed 's/dn/Distinguished-Name/'
	echo "$OUTPUT" | grep "^sAMAccountName:" | sed 's/sAMAccountName/SAM-Account-Name/'
	echo "$OUTPUT" | grep "^cn:" | sed 's/cn/Common-Name/'
	echo "$OUTPUT" | grep "^displayName:" | sed 's/displayName/Display-Name/'
	echo "$OUTPUT" | grep "^mail" | sed 's/mail/E-mail/'
	echo "$OUTPUT" | grep "^department:" | sed 's/department/Department/'
	echo "$OUTPUT" | grep "^extensionAttribute1" | sed 's/extensionAttribute1/Type/'
	echo "$OUTPUT" | grep "^company:" | sed 's/company/Company/'
	echo "$OUTPUT" | grep "^l:" | sed 's/l/Locality-Name/'
	echo "$OUTPUT" | grep "^st:" | sed 's/st/State/'
	echo "$OUTPUT" | grep "^co:" | sed 's/co/Country/'
	echo "$OUTPUT" | grep "^manager:" | sed 's/manager/Manager/'
	echo "$OUTPUT" | grep "^userAccountControl:" | sed 's/userAccountControl/User-Account-Control/'
	echo "$OUTPUT" | grep "^lastLogonTimestamp:" | sed 's/lastLogonTimestamp/Last-Logon-Timestamp/'
	echo "$OUTPUT" | grep "^badPwdCount:" | sed 's/badPwdCount/Bad-Pwd-Count/'
	echo "$OUTPUT" | grep "^pwdLastSet:" | sed 's/pwdLastSet/Pwd-Last-Set/'
	echo "$OUTPUT" | grep "^accountExpires:" | sed 's/accountExpires/Account-Expires/'
	echo "$OUTPUT" | grep "^lockoutTime" | sed 's/lockoutTime/Lockout-Time/'
	echo

fi
