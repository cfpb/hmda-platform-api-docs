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

> ~~Old build/deployment steps~~

> ~~Build from Docker container~~

> ~~1. Build the included Dockerfile which builds the code: `docker build -t=<name:tag> .`~~
> ~~1. Run the container: `docker run -i <name:tag> /bin/bash`~~
> ~~1. Find the container name: `docker container ls`~~
> ~~1. Copy the built files to your local machine: `docker cp <containerName>:./app/build/ ./dockerBuild`~~

> ~~## Publishing~~

> ~~1. **Edit api host variables in ```config.rb``` (bottom of file)**~~

> ~~2. Edit `layout.erb` logo image to link to root~~

> ~~3. Run to publish to gh-pages branch:~~

> ```shell
> ./deploy.sh
> ```

> ~~4. Copy files to _hmda-platform_ repo in gh-pages branch~~

# New Docker/Deploy steps:

## Overall steps:

1. Follow the [docker](#docker) steps.
1. Follow the [deploy to dev GitHib pages](#deploy-to-dev-github-pages) steps.
1. Follow the [deploy to live site](#deploy-to-live-site) steps.

hmda-api docs website has now been updated if all the steps were followed correctly.

### Docker

1. Build the included Dockerfile which builds the code: `docker build -t=<name:tag> .`
1. Run the container: `docker run -i <name:tag> /bin/bash`
1. Find the container name: `docker container ls`
1. Copy the build folder from the docker container to the build directory for your local machine: `docker cp <containerName>:./app/build/. ./build`

### Deploy to Dev GitHub Pages:

##### NOTE: Dev site is located [here](https://cfpb.github.io/hmda-platform-api-docs/#hmda-api-documentation)

1. Deploy contents inside the `./build` directory to gh-pages: `./deploy.sh --push-only`
1. Navigate over to the `Actions` tab in GitHub. An action will fire off to deploy the new build to the dev site. Esnure it went through.
1. Verify content for hmda-api docs looks good by visiting the [dev github pages domain](https://cfpb.github.io/hmda-platform-api-docs/#hmda-api-documentation)

### Deploy to live site:

##### NOTE: Live site is located [here](https://cfpb.github.io/hmda-platform/#hmda-api-documentation)

1. Open and or clone the [hmda-platform repo](https://github.com/cfpb/hmda-platform) locally on your machine.
1. Checkout gh-pages branch: `git checkout gh-pages`
    - Branch ONLY contains the build output from docker
1. Create a new branch and label it with gh-pages and what changes are being made: (i.e `gh-pages-added-file-proxy-api`)
1. Time to copy the contents from the [dev github pages branch](https://github.com/cfpb/hmda-platform-api-docs/tree/gh-pages) into your newly created branch
    - There is no command for this, you will have to **manually** copy/paste the content from the [dev github pages branch](https://github.com/cfpb/hmda-platform-api-docs/tree/gh-pages) to the newly created gh-pages branch in the `hmda-platform` repo.
1. Add changes, commit them and then push the new branch
1. Create a pull request to merge new branch into the master `gh-pages` branch
1. Have the respective people look over the changes
1. Once pull request has been approved, merge the pull request
    - Any push or merges into master `gh-pages` branch will fire off the GitHub Action
1. Head over to the `Actions` tab in GitHub on the `hmda-platform` repo and verify the action was started and got completed
1. Verify new content was added to the live [hmda api docs](https://cfpb.github.io/hmda-platform/#hmda-api-documentation)

If all the steps were followed correctly the [hmda api docs](https://cfpb.github.io/hmda-platform/#hmda-api-documentation) will have been updated.

## References

[Slate](https://github.com/lord/slate) - API Docs Generator
