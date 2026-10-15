FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends findutils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/linux-find-lab

COPY dataset/ /opt/linux-find-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/linux-find-lab/

RUN chmod +x /opt/linux-find-lab/*.sh \
    && chown -R student:student /home/student /opt/linux-find-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/linux-find-lab/start-lab.sh"]