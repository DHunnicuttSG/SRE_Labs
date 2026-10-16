FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/environment-variables-lab

COPY dataset/ /opt/environment-variables-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/environment-variables-lab/

RUN chmod +x /opt/environment-variables-lab/*.sh \
    && chown -R student:student /home/student /opt/environment-variables-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/environment-variables-lab/start-lab.sh"]
