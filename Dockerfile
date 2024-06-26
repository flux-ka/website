FROM alpine:latest

COPY site/ /site/

WORKDIR /site

RUN rm -rf .jekyll-cache 

RUN apk update && apk upgrade
RUN apk add --update ruby bash \
    && apk add git \
    && apk add --virtual build-dependencies build-base ruby-dev libffi-dev \
    && gem install bundler \
    && bundle install \
    && bundle exec jekyll clean \
    && bundle exec jekyll build \
    && gem cleanup \
    && apk del build-dependencies 

EXPOSE 4000