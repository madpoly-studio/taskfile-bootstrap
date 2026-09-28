#!/bin/bash

cat << EOL > Taskfile.yaml
# See https://taskfile.dev/styleguide/#use-the-suggested-ordering-of-the-main-sections
version: '3'

# See https://taskfile.dev/usage/#silent-mode
silent: true

dotenv:
  - ~/.localrc
  - ../.envrc
  - .envrc

includes:
  # internal: Internal tasks are tasks that cannot be called directly by the user
  templates:
    taskfile: https://bit.ly/mps-taskfile
    flatten: true
  default:
    taskfile: .task/templates/GitOpsTasks.yaml
    optional: true
    flatten: true
EOL

task bootstrap --yes
