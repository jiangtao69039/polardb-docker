### poladb for oracle docker image


### build docker image

docker build -t polardbo:test1 .

### run docker image
docker run --name pdtest1 -p 5444:5444 -d polardbo:test1

### change password

 docker exec -it pdtest1 bash
 /usr/local/polardb_o_current/bin/psql -U polardb -p 5444 -d postgres
 ALTER USER polardb WITH PASSWORD 'WVCmFZs841@';


 ### connect with client tool
 psql -U polardb -h 192.168.3.19 -p 5444 -d postgres
