ARG builder_image
ARG server_image=ubi9/nginx-126
FROM ${builder_image} AS builder

COPY ./docs/ ./docs/
COPY ./overrides/ ./overrides/
COPY ./properdocs.yml ./

RUN properdocs build --site-dir="${APP_ROOT}/site/"


FROM ${server_image}

LABEL maintainer="CSC Service Desk <servicedesk@csc.fi>"

COPY --from=builder "${APP_ROOT}/site/" "${NGINX_APP_ROOT}/src/"
COPY ./nginx.conf "${NGINX_CONF_PATH}"

EXPOSE 8000/tcp

CMD ["/usr/sbin/nginx"]
