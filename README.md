# docker-ruby-chrome-firefox
This is a generic docker image. Easy-to-use, you specify your ruby version, specify if you want chrome or firefox or none browser, then it add your ruby gems and your application tests, with a good strategy of "docker layer caching"

# building
- Add this Dockerfile to your project folder
- `docker build . -t myapptest --build-arg BROWSER=chrome --build-arg RUBY_VERSION=2.5`