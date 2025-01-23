@echo off
echo login to mysqlsh using /var/run/mysqld/mysqlx.sock.
for %%n in (1 2 3) do (
  echo dba.checkInstanceConfiguration("clusteradmin@mysql.server%%n")
)

call sqlsh.bat mysql.server1
