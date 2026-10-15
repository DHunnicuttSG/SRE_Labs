FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends passwd util-linux coreutils findutils \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/user-group-admin-lab

COPY dataset/ /opt/user-group-admin-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/user-group-admin-lab/

RUN chmod +x /opt/user-group-admin-lab/*.sh

WORKDIR /root
ENTRYPOINT ["bash", "/opt/user-group-admin-lab/start-lab.sh"]