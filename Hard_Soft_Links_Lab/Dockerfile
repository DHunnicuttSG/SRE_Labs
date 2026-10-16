FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends findutils \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/hard-soft-links-lab

COPY dataset/ /opt/hard-soft-links-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/hard-soft-links-lab/

RUN chmod +x /opt/hard-soft-links-lab/*.sh \
    && chown -R student:student /home/student /opt/hard-soft-links-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/hard-soft-links-lab/start-lab.sh"]