FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/sed-lab

COPY dataset/ /opt/sed-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/sed-lab/

RUN chmod +x /opt/sed-lab/*.sh \
    && chown -R student:student /home/student /opt/sed-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/sed-lab/start-lab.sh"]