FROM ruby:3.3-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
RUN bundle install

COPY app.rb ./

EXPOSE 4567

CMD ["ruby", "app.rb"]
