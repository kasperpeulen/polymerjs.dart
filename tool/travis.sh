#!/bin/bash

# Fast fail the script on failures.
set -e

# Install the bower and vulcanize.
npm install -g bower

# Run the tests.
dart tool/grind.dart test
