# extract the protocol
proto="`echo $DATABASE_URL | grep '://' | sed -e's,^\(.*://\).*,\1,g'`"
# remove the protocol
url=`echo $DATABASE_URL | sed -e s,$proto,,g`

# extract the user and password (if any)
userpass="`echo $url | grep @ | cut -d@ -f1`"
pass=`echo $userpass | grep : | cut -d: -f2`
if [ -n "$pass" ]; then
    user=`echo $userpass | grep : | cut -d: -f1`
else
    user=$userpass
fi

# extract the host -- updated
hostport=`echo $url | sed -e s,$userpass@,,g | cut -d/ -f1`
port=`echo $hostport | grep : | cut -d: -f2`
if [ -n "$port" ]; then
    host=`echo $hostport | grep : | cut -d: -f1`
else
    host=$hostport
fi

name="`echo $url | grep / | cut -d/ -f2-`"

cp /var/www/testlink/install/sql/mysql/testlink_create_tables.sql testlink_create_tables.sql

mysql -h $host -u $user -p$password $name < /var/www/testlink/install/sql/mysql/testlink_create_tables.sql

mysql -h $host -u $user -p$password $name < /var/www/testlink/install/sql/mysql/testlink_create_default_data.sql

cat > /var/www/testlink/config_db.inc.php << EOL
<?php
define('DB_TYPE', 'mysql'); 
define('DB_USER', '$user'); 
define('DB_PASS', '$pass'); 
define('DB_HOST', '$host'); 
define('DB_NAME', '$name'); 
?>
EOL
