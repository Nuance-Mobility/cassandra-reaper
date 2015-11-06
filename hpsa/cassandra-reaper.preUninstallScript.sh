service cassandra-reaper stop
chkconfig --del cassandra-reaper
rm /etc/init.d/cassandra-reaper
