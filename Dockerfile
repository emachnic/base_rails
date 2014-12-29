FROM ruby:2.2-onbuild

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list
RUN apt-get update -q
RUN apt-get install -qy nginx ruby2.2 ruby2.2-dev nodejs sqlite3 libsqlite3-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev lib    curl4-openssl-dev git-core curl libpq-dev
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ADD https://raw.githubusercontent.com/emachnic/base_rails/master/nginx.unicorn.conf /etc/nginx/sites-enabled/default
RUN mkdir -p /usr/src/app/tmp/pids
RUN mkdir -p /usr/src/app/tmp/sockets
RUN mkdir -p /usr/src/app/log

EXPOSE 80

RUN bundle exec unicorn_rails -c config/unicorn/production.rb -E production -D
CMD nginx

