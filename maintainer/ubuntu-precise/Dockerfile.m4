FROM ubuntu:precise
ENV dockersubrdir=/root/docker-context
ENV dockercontextdir=/root/docker-context
RUN install -d "${dockersubrdir}"
RUN install -d "${dockercontextdir}"
ADD debianish.sh /root/docker-context/
RUN sh -ex /root/docker-context/debianish.sh install
RUN sh -ex /root/docker-context/debianish.sh bmake
RUN sh -ex /root/docker-context/debianish.sh bsdowl
ADD ./DOCKER_TARBALL /root/docker-context/
ENV TIMESTAMP="DOCKER_TIMESTAMP"
RUN sh -ex /root/docker-context/prepare_image.sh user\
 && rm -rf /root/docker-context
ENTRYPOINT [ "/bin/su", "-", "anvil" ]
