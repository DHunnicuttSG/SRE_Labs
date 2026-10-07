FROM ubuntu:24.04

RUN useradd --create-home --shell /bin/bash student \
    && mkdir -p /opt/navigation-lab \
    && chown student:student /opt/navigation-lab

COPY setup.sh grade.sh /opt/navigation-lab/
RUN su - student -c 'bash /opt/navigation-lab/setup.sh'

USER student
WORKDIR /home/student
CMD ["bash", "-l"]