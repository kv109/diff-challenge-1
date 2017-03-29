#!/usr/bin/env bash

bundle check || bundle install
bin/rails db:reset
bin/rails s
