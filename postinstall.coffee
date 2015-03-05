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
    "scripts": {}
  }
  """.to file

pkg = JSON.parse cat file

pkg.config ?=

  find_root: "."

  find_mindepth: "2"

  find_maxdepth: "2"

  find_type: "f"

  find_name: "package.json"

  task_install: "echo 'install'; pwd;"

  task_uninstall: "echo 'uninstall'; pwd;"

  task_link: "echo 'link'; pwd;"

  task_test: "echo 'test'; pwd;"

  task_custom: "echo 'custom'; pwd;"

pkg.scripts ?= {}

pkg.tasks ?=

  "clear": "clear"

tasks.map (task) ->

  pkg.scripts["make-#{task}"] ?= "make #{task}"

  pkg.tasks["#{task}"] ?= "npm run make-#{task}"

JSON.stringify(pkg, null, 2).to file

ln '-sf', resolve(__dirname, 'Makefile'), resolve(cwd, 'Makefile')

makeBundle = resolve cwd, 'node_modules', 'make-bundle'

if test '-L', makeBundle

  rm '-Rf', makeBundle

  if ls(dirname(makeBundle)).length is 0

    rm '-Rf', dirname(makeBundle)
