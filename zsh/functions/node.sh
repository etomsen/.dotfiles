#!/usr/bin/env bash

expath() {
  export PATH=$(pwd)/node_modules/.bin/:$PATH
}
