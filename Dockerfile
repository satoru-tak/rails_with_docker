FROM ruby:3.2.2

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo

RUN apt-get update -qq \
  && apt-get install -y postgresql-client vim \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /web
COPY Gemfile /web/Gemfile
COPY Gemfile.lock /web/Gemfile.lock

RUN gem update --system \
  && gem install bundler
RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

COPY . /web

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]