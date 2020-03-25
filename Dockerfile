FROM ruby:2.6.5-slim-stretch

RUN apt-get update -qq \
    && apt-get install \
    -y --no-install-recommends git build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN gem install bundler --no-document \
    && bundle install

## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait $APP_HOME/bin/wait
RUN chmod +x $APP_HOME/bin/wait

COPY . $APP_HOME

COPY deploy/run.sh /run.sh

CMD ["/bin/bash", "/run.sh"]
