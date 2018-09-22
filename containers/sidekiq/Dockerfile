FROM ruby:2.5.1

ENV RAILS_ROOT=/usr/app/apollo-core

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential curl libpq-dev postgresql-client
RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN  bundle install

COPY . .

EXPOSE 3000
