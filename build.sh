#!/bin/bash

set -eux

cd "$(dirname "$0")"

REVISION=${1:-1}

rm -rf output
mkdir -p output

# TODO: Pin this with a separate bundler
gem install fpm

bundle package

pushd output

for GEM in ../vendor/cache/*.gem; do
  fpm -s gem -t deb \
    --prefix /opt/puppetlabs/puppet/lib/ruby/gems/2.4.0 \
    --iteration "${REVISION}~verify-puppet-ruby2.4.0" \
    --architecture all \
    --maintainer "ida-operations@digital.cabinet-office.gov.uk" \
    "$GEM"
done

mkdir -p trusty
mv ./*trusty*.deb trusty/
popd
