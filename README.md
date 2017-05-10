# Casecommons Ruby Docker Image

This repository defines the Casecommons Docker image for running [ruby](https://www.ruby-lang.org/en/).

## Building the Image

To build this image the following prerequisites are required:

- Docker Client with access to a Docker Engine (1.12 or higher)
- Docker Compose 1.7 or higher
- GNU Make 3.82 or higher
- AWS CLI 1.10 or higher
- AWS profile/environment configured with privileges to push images to the ECR repository
- jq

To build the image use the `make release` command:

```
$ make release
=> Building images...
Building app
Step 1/7 : FROM ruby:2.4.0-slim
2.4.0-slim: Pulling from library/ruby
Digest: sha256:846d5ea2c07b738118622539b31e19286a8cc150f90067098ae3b11c04093145
Status: Image is up to date for ruby:2.4.0-slim
 ...
 ...
=> Build complete
=> Starting app service...
Creating network "ruby_default" with the default driver
Creating ruby_app_1
=> Starting ruby service...
Creating ruby_ruby_1
=> Release environment created
=> ruby container is running at http://192.168.99.100:32779`
```

This will:

- Build the ruby image
- Create a release environment that includes a basic Hello World Ruby web application
- Verify ruby is configured correctly installed to run Ruby web application using webrick server

After building the image, you can test the image locally by configuring your browser or environment to use the URL output displayed at the end of the `make release` command.

### Tagging the Image

After building the image, you can tag the image using the `make tag` or `make tag [<tag>...]` command:

```
$ make tag
=> Tagging release image with tags latest 20161211161608.52ce7ab 52ce7ab...
=> Tagging complete
```

Running `make tag` will tag the image with a set of default tags including:

- `latest`
- `<git-commit-timestamp>.<git-commit-hash>`
- `<git-commit-hash>`
- `<git-commit-tag>` if the current commit is tagged

You can create custom tags by specifying one or more tags:

```
$ make tag some-label experimental
=> Tagging release image with tags some-label experimental...
=> Tagging complete
```

### Publishing the Image

With the image tagged, you can login to the AWS EC2 Container Service Registry (ECR) and publish the image using the `make login` and `make release` commands:

```
$ make login
=> Logging in to Docker registry ...
Enter MFA code: xxxxxx
Login Succeeded
=> Logged in to Docker registry
$ make publish
=> Publishing release image to 429614120872.dkr.ecr.us-west-2.amazonaws.com/cwds/ruby...
The push refers to a repository [429614120872.dkr.ecr.us-west-2.amazonaws.com/cwds/ruby]
eb40ed4586e2: Pushed
d93c9b2eda1f: Pushed
66fb5c668a31: Pushed
02535d447192: Pushed
011b303988d2: Pushed
20161211161608.52ce7ab: digest: sha256:f347746ec71c7a1fc00f534af27392b0eec5b8d300c191bb87e74753f7b9bcd6 size: 7708
...
...
=> Publish complete
```

### Role Assumption

When you run the `make login` command, you can attempt to assume an AWS IAM role by setting the `AWS_ROLE` environment variable to the Amazon Resource Name (ARN) of the IAM role to assume.

This is useful for continuous delivery systems that do not have a local AWS CLI environment configured, but have permissions to assume a role that permits publishing of the Docker image to the EC2 Container Registry (ECR) service.

```
$ export AWS_ROLE=arn:aws:iam::429614120872:role/ecrPublisher
$ make login
...
...
```

### Cleaning up

To clean up after building, tagging and publishing the image, use the `make clean` command:

```
$ make clean
Stopping ruby_app_1 ... done
Removing ruby_ruby_1 ... done
Removing ruby_app_1 ... done
Removing network ruby_default
=> Removing dangling images...
=> Clean complete
```

## License

Copyright (C) 2017.  Case Commons, Inc.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

See www.gnu.org/licenses/agpl.html
