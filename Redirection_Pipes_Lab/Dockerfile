FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/redirection-pipes-lab

COPY dataset/ /opt/redirection-pipes-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/redirection-pipes-lab/

RUN chmod +x /opt/redirection-pipes-lab/*.sh \
    && chown -R student:student /home/student /opt/redirection-pipes-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/redirection-pipes-lab/start-lab.sh"]