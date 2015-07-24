cp /opt/cassandra-reaper/cassandra-reaper.service /etc/init.d/cassandra-reaper
chmod +x /etc/init.d/cassandra-reaper
service cassandra-reaper start
chkconfig --add cassandra-reaper
chkconfig cassandra-reaper on
echo "*           soft    nofile          8192" >> /etc/security/limits.conf
echo "*           hard    nofile          16384" >> /etc/security/limits.conf
