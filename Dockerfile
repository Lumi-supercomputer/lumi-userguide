FROM rockylinux:8.5

LABEL maintainer="CSC Service Desk <servicedesk@csc.fi>"

# These need to be owned and writable by the root group in OpenShift
ENV ROOT_GROUP_DIRS='/var/run /var/log/nginx /var/lib/nginx'

RUN yum -y install epel-release &&\
    yum -y install nginx python3 python3-pip git httpd-tools && \
    yum clean all

RUN chgrp -R root ${ROOT_GROUP_DIRS} &&\
    chmod -R g+rwx ${ROOT_GROUP_DIRS}

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt && \
    mkdocs build -d /usr/share/nginx/html

COPY nginx.conf /etc/nginx
COPY entry-point.sh /

EXPOSE 8000

CMD [ "/entry-point.sh" ]
