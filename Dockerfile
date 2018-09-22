FROM ruby:2.5.1

ENV RAILS_ROOT=/usr/app/apollo-core

# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y build-essential curl libpq-dev postgresql-client nodejs
RUN mkdir -p $RAILS_ROOT/tmp/pids

WORKDIR $RAILS_ROOT

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN  bundle install

COPY . .

EXPOSE 3000
CMD ["rails", "s", "-b", "0.0.0.0"]
