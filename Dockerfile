FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev vim iputils-ping

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN mkdir /myapp
WORKDIR /myapp

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

RUN bundle install

COPY . /myapp

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
