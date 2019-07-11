# HMDA Platform Public API

This repo is for the front end public api

## Running locally

You can either do this locally, or with Vagrant:

```shell
# either run this to run locally
bundle install
bundle exec middleman server

# OR run this to run with vagrant
vagrant up
```

You can now see the docs at http://localhost:4567. Whoa! That was fast!

## Build

```shell
bundle exec middleman build --clean
```

## Publishing

1. Edit api host variables in ```config.rb``` (bottom of file)

2. Run to publish to gh-pages branch:

```shell
./deploy.sh
```

3. Copy files to _hmda-platform_ repo in gh-pages branch

## References

[Slate](https://github.com/lord/slate) - API Docs Generator
