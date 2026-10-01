#!/usr/bin/env bash
set -o errexit

bundle install
bin/rails assets:precompile
bin/rails assets:clean
bin/rails db:migrate

if [ "${SEED_DATABASE:-false}" = "true" ]; then
  bin/rails db:seed
fi
