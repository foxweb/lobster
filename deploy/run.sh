#!/bin/bash

set -e

./bin/wait && bundle exec hanami server --server=puma --host 0.0.0.0
