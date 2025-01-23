@echo off
for %%n in (1 2 3) do (
  docker exec -it mysql.server%%n mysql -uroot -proot  -e "CREATE USER 'clusteradmin'@'%%' IDENTIFIED BY 'admin';" 
  docker exec -it mysql.server%%n mysql -uroot -proot  -e "GRANT ALL PRIVILEGES ON *.* TO 'clusteradmin'@'%%' WITH GRANT OPTION;"
  docker exec -it mysql.server%%n mysql -uroot -proot  -e "RESET MASTER;"
)

for %%n in (1 2 3) do (
  docker exec -it mysql.server%%n mysql -uroot -proot ^
  -e "SELECT @@hostname, `user`, `host` FROM mysql.user WHERE `user` = 'clusteradmin';"
)
