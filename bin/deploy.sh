#!/bin/bash

# This is deploy script shell for deploy github blog server.
# Complete the following steps.
# First, clean local cache.
# Second, generate documents.
# Third, deploy server.

# clean
hexo clean

# generate
hexo g

# deploy
hexo d
