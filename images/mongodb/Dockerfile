FROM centos:centos7

RUN yum update -y && yum install -y epel-release

# Downgrade to node 8
RUN yum install -y mongodb-server \
&& mkdir -p /var/lib/mongodb/data



#ENV MONGO_CONF=https://github.com/mongodb/mongo/blob/v2.6/rpm/mongod.conf

#COPY ./conf/ /etc
EXPOSE 27017


CMD ["mongod","-dbpath","/var/lib/mongodb/data"]

VOLUME ["/var/lib/mongodb/data"]

