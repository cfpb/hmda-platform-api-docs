### HMDA Platform Public API

This repo is for the front end public api

### Running locally

You can either do this locally, or with Vagrant:

```shell
# either run this to run locally
bundle install
bundle exec middleman server

# OR run this to run with vagrant
vagrant up
```

You can now see the docs at http://localhost:4567. Whoa! That was fast!

### Publishing

To publish the API, run:

```shell
./deploy.sh
```

### References

[Slate](https://github.com/lord/slate) - API Docs Generator
