FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron procps \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/linux-cron-lab

COPY dataset/ /opt/linux-cron-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/linux-cron-lab/

RUN chmod +x /opt/linux-cron-lab/*.sh \
    && chown -R student:student /home/student /opt/linux-cron-lab

WORKDIR /root
ENTRYPOINT ["bash", "/opt/linux-cron-lab/start-lab.sh"]