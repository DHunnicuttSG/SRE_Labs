FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        hostname \
        procps \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/system-info-and-processes-lab \
    && chown student:student /opt/system-info-and-processes-lab

COPY setup.sh grade.sh /opt/system-info-and-processes-lab/

RUN chmod +x /opt/system-info-and-processes-lab/*.sh \
    && su - student -c 'bash /opt/system-info-and-processes-lab/setup.sh'

USER student
WORKDIR /home/student
CMD ["bash", "-l"]