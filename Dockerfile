FROM alpine:latest AS builder

RUN --mount=type=cache,id=apk-cache,sharing=locked,target=/var/cache/apk \
    apk --update add ruby bash git build-base ruby-dev libffi-dev

WORKDIR /site
COPY site/Gemfile* /site/

RUN --mount=type=cache,target=/root/.gem \
    gem install bundler && bundle install

COPY site/ /site/

RUN --mount=type=cache,target=/site/.jekyll-cache \
    bundle exec jekyll build

FROM nginx:alpine
COPY --from=builder /site/_site /usr/share/nginx/html
