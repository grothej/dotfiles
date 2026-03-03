#!/bin/bash

ctx=$(kubectl config current-context 2>/dev/null || echo "no context")

echo "$ctx"
