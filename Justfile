_default:
  @just --list

all: format lint

format:
  #!/usr/bin/env fish

  fish_indent --write **.fish

lint:
  #!/usr/bin/env fish

  for file in **.fish
    fish --no-execute $file
  end

