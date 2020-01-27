FROM centos:centos7

# This image provides a Node.JS environment you can use to run your Node.JS
# applications.

# Description: centos7 and nodejs docker image


ENV SUMMARY="Platform for building and running Node.js $NODEJS_VERSION applications" \
    DESCRIPTION="Node.js $NODEJS_VERSION available as container is a base platform for \
building and running various Node.js $NODEJS_VERSION applications and frameworks. \
Node.js is a platform built on Chrome's JavaScript runtime for easily building \
fast, scalable network applications. Node.js uses an event-driven, non-blocking I/O model \
that makes it lightweight and efficient, perfect for data-intensive real-time applications \
that run across distributed devices."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="$DESCRIPTION" \
      io.k8s.display-name="Node.js $NODEJS_VERSION" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.deployments-dir="${APP_ROOT}/src" \
      com.redhat.dev-mode.port="DEBUG_PORT:5858"\
      com.redhat.component="rh-$NAME$NODEJS_VERSION-container" \
      name="centos/$NAME-$NODEJS_VERSION-centos7" \
      version="$NODEJS_VERSION" \
      maintainer="SoftwareCollections.org <sclorg@redhat.com>" \
      help="For more information visit https://github.com/djdrisco/kubernetes-centos7-node" 


#build from source
#RUN yum -y update \
#  && yum -y install centos-release-scl \
#  && yum -y install which devtoolset-7-make devtoolset-7-gcc devtoolset-7-gcc-c++ \
#  && curl -sL https://nodejs.org/dist/v8.9.1/node-v8.9.1.tar.gz | tar xz -C /tmp \
#  && cd /tmp/node-v8.9.1 \
#  && scl enable devtoolset-7 "./configure" \
#  && scl enable devtoolset-7 "make -j $(nproc)" \
#  && scl enable devtoolset-7 "make install" \
#  && cd / \
#  && node -v \
#  && npm -v \
#  && rm -rf /tmp/node* \
#  && yum clean all \
#  && rm -rf /var/cache/yum



# works but installs version of node v6.17
#RUN yum install -y epel-release \
#  && yum install -y nodejs \
#  && yum install -y  npm \
#  && yum -y clean all --enablerepo='*'


# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

#use nvm

ENV NODE_VERSION=8.9.3

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash \
  && source ~/.bash_profile \
  && nvm install $NODE_VERSION  \
  && nvm alias default $NODE_VERSION \
   && nvm use $NODE_VERSION

ENV NODE_VERSION=8.9.3
ENV NVM_DIR=~/.nvm
ENV NODE_PATH=$NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


# Install production dependencies.
#RUN npm install --only=production

# Copy local code to the container image.
COPY . ./nodetest


#CMD ["sh","-c", "~/.nvm/versions/node/v8.9.3/bin/npm start"]

# Run the web service on container startup.
CMD [ "npm", "start" ]
ENTRYPOINT ["./nodetest"]
