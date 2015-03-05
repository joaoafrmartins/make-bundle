#!/usr/bin/env shjs

require 'shelljs/global'

{ resolve, dirname } = require 'path'

merge = require 'lodash.merge'

root = resolve __dirname

{ keys } = Object

files = ls root

files.map (file) =>

  pkg = "#{root}/#{file}/package.json"

  if test "-e", pkg

    pkg = JSON.parse cat pkg

    pkg.dependencies ?= {}

    pkg.devDependencies ?= {}

    dependencies = merge pkg.dependencies, pkg.devDependencies

    if keys(dependencies).length > 0

      exec "npm link #{keys(dependencies).join(' ')}"
