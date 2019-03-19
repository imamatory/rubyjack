FROM ruby:2.6.2

RUN gem install bundler

WORKDIR /app

COPY . /app

RUN bundle install

ENTRYPOINT ["/app/entrypoint.sh"]
