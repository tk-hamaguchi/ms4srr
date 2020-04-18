FROM ruby:2.6

ENV APP_ROOT /
ENV PORT 8080

RUN apt-get update -qq && \
    apt-get dist-upgrade -qq && \
    apt-get clean -qq && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

WORKDIR $APP_ROOT
ADD Gemfile* $APP_ROOT

RUN gem install bundler --no-document \
      -v $(grep "BUNDLED WITH" -1 Gemfile.lock | tail -n 1)

RUN bundle config set without 'development test'
RUN bundle config set deployment 'true'
RUN bundle install

ADD . $APP_ROOT

EXPOSE $PORT

CMD bundle exec ruby server.rb
