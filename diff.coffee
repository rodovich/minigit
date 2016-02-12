fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

prefixLines = (string, prefix) ->
  ("#{prefix}#{line}" for line in string.split('\n')).join('\n')

module.exports = ->
  head = fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()
  hash = fs.readFileSync("#{REFS_DIR}/#{head}").toString().trim()
  commit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash}").toString())

  fs.readdir '.', (err, files) ->
    return if err?

    diffs = {}

    for file in files when not fs.statSync(file).isDirectory()
      diffs[file] ?= {}
      diffs[file].local = fs.readFileSync(file).toString()

    for { file, hash } in commit.files
      diffs[file] ?= {}
      diffs[file].committed = fs.readFileSync("#{OBJECTS_DIR}/#{hash}").toString()

    for file, { local, committed } of diffs
      if local isnt committed
        console.log file
        if committed?
          console.log prefixLines(committed, '-')
        if local?
          console.log prefixLines(local, '+')

    return
