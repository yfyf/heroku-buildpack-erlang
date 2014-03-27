## Heroku buildpack: Erlang + rebar + make

This is a fork of the
['official'](https://github.com/archaelus/heroku-buildpack-erlang/) Heroku
buildpack for Erlang apps.

Your project should contain a `Makefile` and it is assumed that
it can be built with `make` and started with `make go`.

The Erlang version is fixed to R16B03-1. If it were possible to pass an ENV
variable to Heroku, you could override it with the env var `OTP_VERSION`. Same
for `REBAR_VSN`. See [compile.mk](bin/compile.mk) for details. I have no idea
if it's possible. If not, just fork and bump the version. Or use the
multi-buildpacks and set it there. Or something.

The goal here is to have a non-intrusive buildpack, so that you don't have to
pollute your project with Heroku specific files.

### Configure your Heroku app to use this buildpack:

    heroku config:add \
        BUILDPACK_URL="https://github.com/yfyf/heroku-buildpack-erlang.git" \
        -a YOUR_APP

or

    heroku create --buildpack \
        "https://github.com/yfyf/heroku-buildpack-erlang.git"
