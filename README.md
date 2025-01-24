### MySQL Cluster Replication LAB

**Requirements:**
- docker + docker-compose
- Percona xtrabackup

**TODO:**

- ✅ docker-compose for Cluster Setup
- ⬛ Backup & Restore
- ⬛ BCP Scenarios

### Cluster Setup

**Initialize a cluster**

1. Start the servers. It is recommended to have at least 3 servers for high-availability setup.
2. Create the `clusteradmin` account in all servers

```sql
CREATE USER 'clusteradmin'@'%%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'clusteradmin'@'%%' WITH GRANT OPTION;
RESET MASTER;
```

3. Use `mysqlsh` login to any server to initialize the cluster

```sh
mysqlsh -uclusteradmin -hmysql.server1
```

```js
// check the member instance for cluster configuration issues. Correct them in my.ini
dba.checkInstanceConfiguration("clusteradmin@mysql.server1");
dba.checkInstanceConfiguration("clusteradmin@mysql.server2");
dba.checkInstanceConfiguration("clusteradmin@mysql.server3");
// create the cluster in mysql.server1, this will make the mysql.server1 the PRIMARY
dba.createCluster("clusterName");
// join the members
cluster = dba.getCluster();
cluster.addInstance("clusteradmin@mysql.server2");
cluster.addInstance("clusteradmin@mysql.server3");
// configure member weights to control the election of master. The higher the value, the more likely the member will be elected as PRIMARY.
cluster.setInstanceOption("mysql.server1", "memberWeight", 2); // internal network
cluster.setInstanceOption("mysql.server2", "memberWeight", 2); // internal network failover
cluster.setInstanceOption("mysql.server3", "memberWeight", 1); // cloud backup failover
// verify the cluster options
cluster.options();
// check the cluster status
cluster.status();
```

### BCP Scenarios

**Recovering the custer from complete outage**

1. Start the servers
2. use `mysqlsh` to connect to any member of the cluster and reboot from complete outage.

```js
shell.connect("clusteradmin@mysql.server1");
dba.rebootClusterFromCompleteOutage();
cluster = dba.getCluster();
cluster.status();
```

3. restart the mysql-router

**Manually set the cluster PRIMARY**

Given: the current PRIMARY is the cloud backup for failover. After the other cluster members have recovered from outage, we need to change the current PRIMARY for better performance.

```js
cluster = dba.getCluster();
cluster.status(); // repeat until the members are ONLINE
cluster.setPrimaryInstance("mysql.server1");
```

**Links:**

- [Creating mysql8 cluster form existing database](https://medium.com/enigma-shards/creating-mysql8-cluster-from-existing-database-3639bac921b1)
- [Group Replication Failed. Error 3094(HY000)](https://all-database-soultions.blogspot.com/2021/11/mysql-innodb-cluster-restorecreate.html)
- [Restore Cluster from mysqlbackup](https://all-database-soultions.blogspot.com/2021/11/Restore-Mysql-InnoDB-Cluster-using-mysqlbackup.html)
