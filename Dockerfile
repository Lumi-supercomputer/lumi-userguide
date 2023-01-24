FROM rockylinux:8.5

LABEL maintainer="CSC Service Desk <servicedesk@csc.fi>"

# These need to be owned and writable by the root group in OpenShift
ENV ROOT_GROUP_DIRS='/var/run /var/log/nginx /var/lib/nginx'

RUN yum -y install epel-release && yum -y install yum-utils
# This was introduced after doc failed to build with error: "missing groups or modules: nginx:mainline"
RUN echo "[nginx-mainline]"                                             > /etc/yum.repos.d/nginx.repo && \
    echo "name=nginx mainline repo"                                    >> /etc/yum.repos.d/nginx.repo && \
    echo "baseurl=http://nginx.org/packages/mainline/centos/8/x86_64/" >> /etc/yum.repos.d/nginx.repo && \
    echo "gpgcheck=1"                                                  >> /etc/yum.repos.d/nginx.repo && \
    echo "enabled=0"                                                   >> /etc/yum.repos.d/nginx.repo && \
    echo "gpgkey=https://nginx.org/keys/nginx_signing.key"             >> /etc/yum.repos.d/nginx.repo && \
    echo "module_hotfixes=true"                                        >> /etc/yum.repos.d/nginx.repo && \
    yum-config-manager --enable nginx-mainline

RUN yum -y install nginx python3 python3-pip git httpd-tools && \
    yum clean all

RUN mkdir -p ${ROOT_GROUP_DIRS} && \
    chgrp -R root ${ROOT_GROUP_DIRS} &&\
    chmod -R g+rwx ${ROOT_GROUP_DIRS}

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt && \
    mkdocs build -d /usr/share/nginx/html

COPY nginx.conf /etc/nginx
COPY entry-point.sh /

RUN chmod +x entry-point.sh

EXPOSE 8000

CMD [ "/entry-point.sh" ]
