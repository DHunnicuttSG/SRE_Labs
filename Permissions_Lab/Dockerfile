FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        sudo \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd developers \
    && useradd --create-home --user-group --shell /bin/bash student \
    && useradd --create-home --user-group --shell /bin/bash student1 \
    && usermod -aG developers student \
    && usermod -aG developers student1 \
    && printf 'student ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/student \
    && chmod 0440 /etc/sudoers.d/student \
    && mkdir -p /opt/permissions-lab \
    && chown student:student /opt/permissions-lab

COPY setup.sh grade.sh start-lab.sh STUDENT.md /opt/permissions-lab/

RUN chmod +x /opt/permissions-lab/*.sh \
    && bash /opt/permissions-lab/setup.sh \
    && chown -R student:student /home/student/permissions_lab

USER student
WORKDIR /home/student
ENTRYPOINT ["bash", "/opt/permissions-lab/start-lab.sh"]