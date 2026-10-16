FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/systemctl-lab

COPY dataset/ /opt/systemctl-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/systemctl-lab/

RUN chmod +x /opt/systemctl-lab/*.sh /opt/systemctl-lab/dataset/bin/* \
    && chown -R student:student /home/student /opt/systemctl-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/systemctl-lab/start-lab.sh"]
