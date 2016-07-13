FROM ubuntu:16.04

MAINTAINER NGINX Docker Maintainers "docker-maint@nginx.com"

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx \
						gettext-base \
						cron \
						git \
						ssmtp \
						ssh \
						vim \
						curl \
	&& curl -sL https://deb.nodesource.com/setup_4.x | bash - \
	&& apt-get install --yes nodejs \
	&& rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_LOGLEVEL warn
ENV NODE_VERSION 4.3.2

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /var/www/site

# install npm stuff
RUN npm install -g bower gulp-cli webpack
RUN echo '{ "allow_root": true }' > /root/.bowerrc

WORKDIR /var/www/site

ADD ssmtp.conf /etc/ssmtp/ssmtp.conf
ADD start.sh crons.conf post-merge /root/
ADD default.conf /etc/nginx/sites-enabled/default

#Add cron job
RUN crontab /root/crons.conf

EXPOSE 80

CMD ["/root/start.sh"]
