FROM rockylinux:9

LABEL maintainer="CSC Service Desk <servicedesk@csc.fi>"

# These need to be owned and writable by the root group in OpenShift
ENV ROOT_GROUP_DIRS='/var/run /var/log/nginx /var/lib/nginx'

RUN dnf --refresh --assumeyes install nginx python3.12 python3.12-pip && \
    dnf clean all

RUN chgrp -R root ${ROOT_GROUP_DIRS} && \
    chmod -R g+rwx ${ROOT_GROUP_DIRS}

COPY --parents \
  ./docs ./mkdocs_lumi ./mkdocs.yml ./requirements.txt \
  ./

ARG PIP_ROOT_USER_ACTION=ignore

RUN python3.12 -m pip install --upgrade pip && \
    python3.12 -m pip install --no-cache-dir --no-deps --requirement requirements.txt && \
    python3.12 -m mkdocs build -d /usr/share/nginx/html

COPY nginx.conf /etc/nginx

EXPOSE 8000

CMD ["/usr/sbin/nginx"]
