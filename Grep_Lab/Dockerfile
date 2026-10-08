FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/grep-lab

COPY dataset/ /opt/grep-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/grep-lab/

RUN chmod +x /opt/grep-lab/*.sh \
    && chown -R student:student /home/student /opt/grep-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/grep-lab/start-lab.sh"]