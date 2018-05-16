#!/bin/bash
find . -path ./Carthage -prune -o -name "*.swift" -print0 ! -name "/Carthage" | xargs -0 wc -l