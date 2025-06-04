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

template_files=($(find .task/templates/project -type f -name '*.gomplate'))
for _file in "${template_files[@]}"; do
  file=$(basename "${_file%.gomplate}")
  dest="$file"
  # For backwards compatibility with helmfile v0. Helmfile v1 uses helmfile.yaml.gotmpl in case you want helmfile to render it as a go template before yaml parsing
  if [[ "$file" == "helmfile.yaml"* ]]; then
    dest="helmfile.yaml.gotmpl"
    file="helmfile.yaml"
  fi
  if grep -q "$file" .gitignore; then
    echo "cp $_file $dest"
    cp "$_file" "$dest"
  fi
done
