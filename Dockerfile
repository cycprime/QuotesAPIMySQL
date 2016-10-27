FROM mysql:5.7

LABEL description="QuotesAPI MySQL database Docker image." \ 
      version="0.1" \
      author="cycprime"

# Version of this image
ENV QUOTEAPI_MYSQL_IMG_VER=0.1 \
    QUOTEAPI_MYSQL_IMG_NAME="quotesapi_mysql" \
    QUOTEAPI_MYSQL_IMG_DESC="Test image for QuotesAPI MySQL database."

# Add in script to initialize database instances and database user.
# COPY scripts/init_db_instance.sql /docker-entrypoint-initdb.d/init_instance.sql
COPY scripts/* /docker-entrypoint-initdb.d/

# Using the traditional port for MySQL
# EXPOSE 3306

# Specify the directories that can be mounted
# VOLUME /var/lib/mysql
