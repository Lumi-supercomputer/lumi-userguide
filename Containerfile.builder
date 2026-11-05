ARG base_image=ubi9/python-312
FROM ${base_image}

LABEL maintainer="CSC Service Desk <servicedesk@csc.fi>"

COPY ./requirements.txt ./

RUN \
  pip install --upgrade pip \
&& \
  pip install \
        --use-pep517 \
        --no-cache-dir \
        --no-deps \
        --requirement=requirements.txt
