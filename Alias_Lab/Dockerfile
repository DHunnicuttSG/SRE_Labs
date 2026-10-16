FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/alias-lab

COPY dataset/ /opt/alias-lab/dataset/
COPY setup.sh grade.sh start-lab.sh /opt/alias-lab/

RUN chmod +x /opt/alias-lab/*.sh \
    && chown -R student:student /home/student /opt/alias-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/alias-lab/start-lab.sh"]