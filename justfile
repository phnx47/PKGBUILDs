#!/usr/bin/env -S just --justfile

default:
  just nvcheck

add pkgname:
  git submodule add -b master -f ssh://aur@aur.archlinux.org/{{pkgname}}.git
  git config -f .gitmodules submodule.{{pkgname}}.ignore untracked
  .scripts/sort.gitmodules.sh
  git add .gitmodules && git commit -m "add '{{pkgname}}' pkg"

remove pkgname:
  git rm -f {{pkgname}}
  rm -rf .git/modules/{{pkgname}}
  git config --remove-section submodule.{{pkgname}}
  git commit -m "remove '{{pkgname}}' pkg"

init:
  git submodule update --init
  git submodule foreach "git config --local status.showUntrackedFiles no && git checkout master"

pull:
  git submodule foreach git pull origin master

publish pkgname:
  cd {{pkgname}}; git push

nvcheck:
  .scripts/nvcheck.sh

update pkgname:
  .scripts/update.sh {{pkgname}}
