### MySQL Cluster Replication LAB

**TODO:**

- ✅ docker-compose for Cluster Setup
- ⬛ Backup & Restore
- ⬛ BCP Scenarios

### BCP Scenarios

**Recovering the custer from complete outage**

1. Start the servers
2. use `mysqlsh` to connect to any member of the cluster and reboot from complete outage.

```js
shell.connect("clusteradmin@mysql.server1");
dba.rebootClusterFromCompleteOutage();
cluster = dba.getCluster();
cluster.describe();
```

3. reboot the mysql-router
