#!/bin/sh
set -x

source /etc/opt/opsware/pytwist/pytwist.conf

function get_cust_attr() {
	cust_attr="$1"
	value="`$AGENTTOOLSPATH/get_cust_attr.sh ${cust_attr}`"
	if [ $? != 0 ]; then
		value=""
	fi
	echo "$value"
}

## Configure Service ##
REAPER_CONFIG=/opt/cassandra-reaper/cassandra-reaper.yaml

storageType="`get_cust_attr storageType`"
if [ ! -z "$storageType" ]; then
		/bin/sed -i "s/storageType: memory/storageType: $storageType/g" "$REAPER_CONFIG"
fi

databaseUser="`get_cust_attr databaseUser`"
if [ ! -z "$databaseUser" ]; then
		/bin/sed -i "s/user: pg-user/user: $databaseUser/g" "$REAPER_CONFIG"
fi

databasePassword="`get_cust_attr databasePassword`"
if [ ! -z "$databasePassword" ]; then
		/bin/sed -i "s/password: pg-pass/password: $databasePassword/g" "$REAPER_CONFIG"
fi

databaseUrl="`get_cust_attr databaseUrl`"
if [ ! -z "$databaseUrl" ]; then
		/bin/sed -i "s|url: jdbc:postgresql://db.example.com/db-prod|url: $databaseUrl|g" "$REAPER_CONFIG"
fi

#Check that all DB settings were provided
if [ ! -z "$databaseUser" -o ! -z "$databasePassword" -o ! -z "$databaseUrl" ]; then
		if [ -z "$databaseUser" -o -z "$databasePassword" -o -z "$databaseUrl" ]; then
        echo "Missing database settings (databaseUser:$databaseUser), (databasePassword:$databasePassword), (databaseUrl:$databaseUrl)"
        exit 1
    fi
fi

## Enabled Service ##
cp /opt/cassandra-reaper/cassandra-reaper.service /etc/init.d/cassandra-reaper
chmod +x /etc/init.d/cassandra-reaper
service cassandra-reaper start
chkconfig --add cassandra-reaper
chkconfig cassandra-reaper on
