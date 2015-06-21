FROM ruby:2.2.2

RUN apt-get update && apt-get install -y locales --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN echo "Asia/Tokyo" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update && apt-get install -y mysql-client nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN echo "deb http://www.deb-multimedia.org jessie main non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --force-yes deb-multimedia-keyring --no-install-recommends && \
    apt-get install -y --force-yes rtmpdump ffmpeg swftools --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/yayugu/niconico.git && cd niconico && git checkout 4c898e2

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle install -j4

RUN mkdir /app
WORKDIR /app
ADD . /app
