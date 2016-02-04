FROM hub.bccvl.org.au/centos/centos7-epel:2016-02-04

# install official postgres repo
RUN yum -y install http://yum.postgresql.org/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm

# install postgres and postgis
RUN yum -y install postgresql95-server \
                   postgresql95-contrib \
                   postgis2_95 && \
    yum clean all

# add start script
COPY files/cmd.sh /cmd.sh
RUN chmod +x /cmd.sh

EXPOSE 5432

CMD /cmd.sh
