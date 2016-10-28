# QuotesAPI_MySQL
`cycprime/quotesapi_mysql` contains the docker scripts that is required to create the image for an empty database instance for running QuotesAPI.

## cycprime/quotesapi_mysql Docker Images
The available verions of `cycpriime/quotesapi_mysql` are:

> QuotesAPI_MySQL version 0.1.0 (tag: 0.1 as well as latest)

## To Build the quotesapi_mysql Image
The `quotesaapi_mysql` image is built on top of mysql version 5.7.

MySQL image supports the initialization of the database via SQL scripts in the `/docker-entrypoint-initdb.d` directory.  The `quotesapi_mysql` image also takes advantage of this feature and will copy any scripts in the local `scripts` directory to the image's `/docker-entrypoint-initdb.d` directory.

A sample of the initialization script can be found under the `Samples` directory.  To customize the database initialization, copy the sample script into the `scripts` directory:

    > cp Samples/init_db_instance.sql scripts/

Then, modify the script `scripts/init_db_instance.sql` with your favourite text editor and customize the  initialization of the database accordingly.

Once the initialization script is in place, build the image by typing the following: 

    > docker build -t quotesapi_mysql .

## To Use the quotesapi_mysql Image
To run the image in a container, do the following:
	
~~~~
docker run --name <my_quoteapimysql_container_name> \
           --detach \
           --env-file ./env/runtime/<environment_file> \
           --volume <my_data_volume_name>:/var/lib/mysql \
           --publish <host port>:<container port> \
           cycprime/quotesapi_mysql:latest
~~~~

*<my_quoteapimysql_container_name>* is the name of the container running the `cycprime/quotesapi_mysql` image.

*`./env/runtime/<environment_file>`* is the file path and name of the file containing the environment variables required my MySQL container to run.  

*<my_data_volume_name>* is the name of the data volume that holds the MySQL database data.

A sample command will resemble the following:

    > docker run --name test_container_01 \
                 --detach \
                 --env-file ./env/runtime/default.env \
                 --volume my_data_volume:/var/lib/mysql \
                 --publish 127.0.0.1:4306:3306 \
                 quotesapi_mysql

To see the process status:

    > docker ps -a

To review the log of the container, do the following:

    > docker logs test_container_01 

To access the container:

    > docker exec -it test_container_01 /bin/bash

To stop the container:

    > docker stop test_container_01
    
To delete the container:

    > docker rm test_container_01

To list all Docker data volumes:

    > docker volume ls
    
To inspect the data volume:

    > docker volume inspect my_data_volume
    
For a full list of docker commands, please refer to Docker's documentation [The Docker commands](https://docs.docker.com/engine/reference/commandline/).

### Database Root User Password and Environment Variables
When running an instance of the image, the image expects a root password to be passed in.  This password can be passed in via an environment variable.  Since there are quite a few of these environment variables one can specify, the command makes use of an environment variable file, instead of enumerating each environment variable individually.  To specify one's own environment variable file, simply copy the sample from `Samples/
default.env` to the `env/runtime/` directory:

    > cp Samples/default.env env/runtime/default.env

and modify the file `env/runtime/default.env` with your favourite text edit.

The full list of environment variables supported by MySQL is available at [MySQL/MySQL-Docker](https://github.com/mysql/mysql-docker).  They can be added to the `env/runtime/default.env` file and adjusted accordingly.

By having these environment variables specified in the file instead of enumerating them on the command line minimize the chance of passwords being readily accessible via `ps` command or command history.

### Data Store
MySQL data is stored in `/var/lib/mysql`.  To allow data to persist beyond the life cycle of the image container, the image has a mount point at `/var/lib/mysql`.  You can specify your own named data volume and map it to `/var/lib/mysql`.  This is done via the `--volume <my_data_volume_name>:/var/lib/mysql` option in the `docker run`  command.

If this option is omitted, `/var/lib/mysql` will be mounted to an annoymous data volume in Docker.  Whether it is a named data volume, or an annoymous data volume, the data will still persist even if the image container is deleted.  To remove a data volume, use the `docker volume rm` command.  



### Adding Network
To create a network for the container:

    > docker network create --driver bridge quotesapi-db-network

To connect the container to the `quotesapi-db-network`:

    > docker network connect quotesapi-db-network test_container_01
    
To check out the details on a network:

    > docker network inspect quotesapi-db-network 

To disconnect a container from a network:

    > docker network disconnect quotesapi-db-network test_container_01

To remove a network

    > docker network  rm quotesapi-db-network

## Starting Container via docker-compose
Alternatively, if docker-compose is supported, simply do the following to bring up a container:

    > docker-compose up -d
    
To stop the container:

    > docker-compose down
    
The `docker-compose` will bring up a container by the name, `quotesapi_mysql_container`, as specified in the `docker-compose.yml` file.  The database will run in its own network called `db_net` and it exposes port 4306 on the host for database connection.  Database is stored in a named volume called `quotesdb`.  (Usually, both the container name as well as the data volume name will be prefixed by the project name.  The project name is set to the directory name if it is not specified otherwise to `docker-compose`.)

If you build your own image locally, or if you pull an image from Docker Hub, you may need to adjust the db image name in the `docker-compose.yml` file accordingly.
