@echo off
if "%1"=="" (
  echo usage: sqlsh hostname
) else (
  docker run -it --rm --network mysql-replication-lab_default mysql:8.0.40 mysqlsh -uroot -proot -h%1  
)
