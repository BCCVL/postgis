FROM hub.bccvl.org.au/centos/centos7-epel:2016-04-15

# install official postgres repo
RUN yum -y install http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm

# install postgres and postgis
RUN yum -y install postgresql95-server \
                   postgresql95-contrib \
                   postgis2_95 \
                   cronie \
                   ssmtp && \
    yum clean all

RUN yum -y install cronie ssmtp

# add backup scripts
COPY files/pg_backup.sh files/pg_backup_rotated.sh /usr/bin/
COPY files/pg_backup.config /etc/postgis/

# add start script
COPY files/cmd.sh /cmd.sh
RUN chmod +x /cmd.sh

EXPOSE 5432

CMD /cmd.sh
