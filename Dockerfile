FROM ubuntu:xenial
LABEL authors="dididi <dfdgsdfg@gmail.com>, Giovanni Angoli <juzam76@gmail.com>"

ENV HOME /root
ENV LC_ALL C.UTF-8

RUN apt-get update && \
    apt-get -y install build-essential \
                       git \
                       libncursesw5-dev \
                       bison \
                       flex \
                       liblua5.1-0-dev \
                       libsqlite3-dev \
                       libz-dev \
                       pkg-config \
                       libsdl-image1.2-dev \
                       libsdl-mixer1.2-dev \
                       libsdl1.2-dev \
                       libfreetype6-dev \
                       libpng-dev \
                       python-pip \
                       ttf-dejavu-core && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip install tornado==3.2.2

RUN git clone -v https://github.com/crawl/crawl.git

WORKDIR /crawl
RUN git submodule update --init

WORKDIR /crawl/crawl-ref/source
RUN make WEBTILES=y USE_DGAMELAUNCH=y
RUN mkdir rcs

WORKDIR /crawl/crawl-ref/source/webserver
RUN sed -i '/bind_port/ s|8080|80|' config.py
RUN sed -i '/password_db/ s|./webserver/passwd.db3|/data/passwd.db3|' config.py
RUN sed -i '/filename/ s|#||' config.py
RUN sed -i '/filename/ s|webtiles.log|/data/webtiles.log|' config.py
# RUN sed -i '/crypt_algorithm/ s|broken|6|' config.py
# RUN sed -i '/crypt_salt_length/ s|16|16|' config.py

WORKDIR /crawl/crawl-ref/source
CMD python webserver/server.py

VOLUME ["/data"]
EXPOSE 80 443

