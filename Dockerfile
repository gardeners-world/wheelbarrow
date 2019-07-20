FROM ruby:2.6-slim

RUN apt-get update && apt-get install -y make build-essential

COPY wheelbarrow/gems.rb /opt/wheelbarrow/
WORKDIR /opt/wheelbarrow
RUN bundle install

COPY wheelbarrow/ /opt/wheelbarrow
