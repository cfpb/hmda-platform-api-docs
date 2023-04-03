# HMDA Platform Public API

This repo is for the front end public api that lives here: https://cfpb.github.io/hmda-platform/

## Prerequisite
Have `homebrew` and `ruby` installed

_Recommended to use rbenv and ruby-build from `homebrew`, and specify the ruby version in [.ruby-version](./.ruby-version)_
```shell
brew install rbenv ruby-build
RUBY_VERSION=2.4.1
ruby-build $RUBY_VERSION $HOME/.rbenv/versions/$RUBY_VERSION
```

Install bundler
```shell
gem install bundler
```

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

# Docker/Deploy steps:

## Deployment overview:
1. [Docker Build](#docker-build)
2. [Deploy to Dev](#deploy-to-dev)
4. [Deploy to Prod](#deploy-to-prod)


### Docker Build

1. Build the included Dockerfile: `docker build -t=hmdaapidocs .`
2. Run the container: `docker run -i hmdaapidocs /bin/bash`
3. Find the container ID: `docker container ls | grep hmdaapidocs | awk '{split($0,a," "); print a[1]}'`
4. Copy the build folder from the docker container to the build directory for your local machine: `docker cp <containerID>:./app/build/. ./build`

### Deploy to Dev:

1. Deploy the `./build` folder to the [Dev site](https://cfpb.github.io/hmda-platform-api-docs) by pushing it's contents to the `gh-pages` branch : `./deploy.sh --push-only`
2. You can check the deployment status on the [Actions](https://github.com/cfpb/hmda-platform-api-docs/actions) tab in GitHub.
3. Visit the [Dev site](https://cfpb.github.io/hmda-platform-api-docs) and verify the updates are correct. 

### Deploy to Prod:

1. Open the [hmda-platform repo](https://github.com/cfpb/hmda-platform)
2. Checkout gh-pages branch: `git checkout gh-pages`
    - Branch ONLY contains the build output from docker
3. Create a new branch and label it with gh-pages and what changes are being made: (i.e `git checkout -b gh-pages-added-file-proxy-api`)
4. Copy the contents from hmda-platform-api-docs `./build` into your newly created branch: `cp -r ../hmda-platform-api-docs/build/* ./`
5. Add changes, commit them and then push the new branch: `git add --all && git commit -m "Change description" && git push`
6. Create a pull request to merge new branch into the `gh-pages` branch
7. Have the respective people review the changes
8. Merge the approved pull request
9. Visit the [hmda-platform Actions](https://github.com/cfpb/hmda-platform/actions) page to check the deployment status
    - Deploy action is triggered by any push or mergee into the `gh-pages` branch
10. Verify new content was added to the [Prod api docs](https://cfpb.github.io/hmda-platform)

## References

[Slate](https://github.com/lord/slate) - API Docs Generator
