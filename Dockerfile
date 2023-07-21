FROM ruby:alpine3.18 as base
RUN apk add build-base git

FROM base as build
COPY Gemfile Gemfile.lock ./
RUN bundle install

FROM base
WORKDIR /block-checker
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . ./
ENTRYPOINT ["./script/report-blocks"]
