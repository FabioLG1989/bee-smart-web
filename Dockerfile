FROM ruby:2.6.3

ENV RAILS_LOG_TO_STDOUT true

RUN mkdir /beesmart
WORKDIR /beesmart

COPY Gemfile ./
COPY Gemfile.lock ./

RUN bundle install --without development test

COPY . ./

COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
