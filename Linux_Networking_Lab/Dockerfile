FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dnsutils \
        iproute2 \
        iputils-ping \
        netcat-openbsd \
        python3 \
        traceroute \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/linux-networking-lab \
    && chown student:student /opt/linux-networking-lab

COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/linux-networking-lab/

RUN chmod +x /opt/linux-networking-lab/*.sh \
    && su - student -c 'bash /opt/linux-networking-lab/setup.sh'

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/linux-networking-lab/start-lab.sh"]