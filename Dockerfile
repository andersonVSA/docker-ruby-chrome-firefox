ARG RUBY_VERSION=2.6.3
ARG BROWSER=NONE
#=========
#BASE IMAGE
#=========
FROM ruby:${RUBY_VERSION} as base-ruby
LABEL maintainer "Anderson Sant'Ana <andvsantana@gmail.com>"

#=========
# CHROME-IMAGE, If team pass argument BROWSER=CHROME, then Install chrome browser
#=========
FROM base-ruby AS base-ruby-CHROME

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list

# Install webdrivers gem for chrome and firefox browsers
RUN gem install webdrivers

#=========
# FIREFOX-IMAGE, If team pass argument BROWSER=FIREFOX, then Install firefox browser
#=========
FROM base-ruby AS base-ruby-FIREFOX
RUN mkdir /opt/firefox
RUN wget --no-verbose -O /tmp/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" \
#RUN wget -O /tmp/firefox.tar.bz2 "https://download-installer.cdn.mozilla.net/pub/firefox/releases/65.0/linux-x86_64/en-US/firefox-65.0.tar.bz2" \
   && rm -rf /opt/firefox \
   && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
   && rm /tmp/firefox.tar.bz2 \
   && ln -fs /opt/firefox /usr/bin/firefox
ENV PATH="/usr/bin/firefox:${PATH}"
RUN apt-get update -qqy \
   && apt-get -qqy install libgtk-3-dev

# Install webdrivers gem for chrome and firefox browsers
RUN gem install webdrivers

#=========
#DO MORE NOTHINK if none browser was pointed, and make a IMAGE ONLY WITH RUBY.
#=========
FROM base-ruby as base-ruby-NONE

#=========
#YOUR TEST APP CONTAINERIZED, based in image builded by arguments
#=========
FROM base-ruby-${BROWSER} as base-ruby-final
# Creates Application root
RUN mkdir -p /APP_ACCEPT_TESTS
WORKDIR /APP_ACCEPT_TESTS
# Ensure gems are cached and only get updated when they change
COPY Gemfile Gemfile.lock ./
RUN bundle install
# Copy aplication code from work station
COPY . /APP_ACCEPT_TESTS
