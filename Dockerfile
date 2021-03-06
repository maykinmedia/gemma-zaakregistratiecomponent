# Stage 1.1 - Compile needed python dependencies
FROM python:3.6-alpine AS build
RUN apk --no-cache add \
    gcc \
    musl-dev \
    pcre-dev \
    linux-headers \
    postgresql-dev \
    python3-dev \
    # libraries installed using git
    git \
    # lxml dependencies
    libxslt-dev \
    # pillow dependencies
    jpeg-dev \
    openjpeg-dev \
    zlib-dev

WORKDIR /app

COPY ./requirements /app/requirements
RUN pip install -r requirements/production.txt

# Stage 1.2 - Compile needed frontend dependencies
RUN apk --no-cache add \
    # node.js
    nodejs \
    nodejs-npm

COPY ./*.json /app/

RUN npm install

# Stage 1.3 - Copy source code
COPY ./src /app/src

# Stage 2 - Build docker image suitable for execution and deployment
FROM python:3.6-alpine
RUN apk --no-cache add \
    ca-certificates \
    mailcap \
    musl \
    pcre \
    postgresql \
    # lxml dependencies
    libxslt \
    # pillow dependencies
    jpeg \
    openjpeg \
    zlib

# install all the dependencies for GeoDjango
RUN apk --no-cache add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    libressl2.7-libcrypto

RUN apk --no-cache add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    gdal-dev \
    geos \
    proj4

COPY --from=build /usr/local/lib/python3.6 /usr/local/lib/python3.6
COPY --from=build /usr/local/bin/uwsgi /usr/local/bin/uwsgi
COPY --from=build /app/src /app/src
COPY ./bin/docker_start.sh /start.sh
RUN mkdir /app/log

WORKDIR /app
EXPOSE 8000
CMD ["/start.sh"]
