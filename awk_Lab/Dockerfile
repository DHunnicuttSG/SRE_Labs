FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends gawk \
    && update-alternatives --install /usr/local/bin/awk awk /usr/bin/gawk 100 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/awk-lab

COPY dataset/ /opt/awk-lab/dataset/
COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/awk-lab/

RUN chmod +x /opt/awk-lab/*.sh \
    && chown -R student:student /home/student /opt/awk-lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/awk-lab/start-lab.sh"]