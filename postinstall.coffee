#!/usr/bin/env shjs

require 'shelljs/global'

{ resolve, dirname } = require 'path'

cwd = null

list = grep '.PHONY', resolve __dirname, 'Makefile'

tasks = list.replace(/^\.PHONY\:\s|\n/g, '').split ' '

process.env.PATH.split(":").map (dir) ->

  if dir.match(/\.bin$/) and not dir.match(/make-bundle/)

    cwd = dirname dirname dir

file = resolve cwd, 'package.json'

if not test '-f', file

  """
  {
    "name": "",
    "private": true,
    "version": "0.0.0",
    "scripts": {
      "make-install": "make install",
      "make-uninstall": "make uninstall",
      "make-link": "make link",
      "make-test": "make test",
      "make-clean": "make clean",
      "make-create": "make create",
      "make-publish": "make publish",
    },
    "config": {
      "find_root": ".",
      "find_mindepth": "2",
      "find_maxdepth": "2",
      "find_type": "f",
      "find_name": "package.json",
      "task_install": "spaghetty install -li",
      "task_uninstall": "spaghetty install -u",
      "task_link": "spaghetty install -li",
      "task_test": "echo 'test'; pwd;",
      "task_create": "spaghetty github --delete && spaghetty github --create --commit",
      "task_publish": "spaghetty github --commit"
    },
    "tasks": {
      "clear": "clear",
      "install": "npm run make-install",
      "uninstall": "npm run make-uninstall",
      "link": "npm run make-link",
      "test": "npm run make-test",
      "clean": "npm run make-clean",
      "create": "npm run make-create",
      "publish": "npm run make-publish"
    }
  }
  """.to file

JSON.stringify(pkg, null, 2).to file

ln '-sf', resolve(__dirname, 'Makefile'), resolve(cwd, 'Makefile')

makeBundle = resolve cwd, 'node_modules', 'make-bundle'

if test '-L', makeBundle

  rm '-Rf', makeBundle

  if ls(dirname(makeBundle)).length is 0

    rm '-Rf', dirname(makeBundle)
