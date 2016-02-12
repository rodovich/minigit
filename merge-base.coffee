fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

module.exports = (branch1, branch2) ->
  hash1 = fs.readFileSync("#{REFS_DIR}/#{branch1}").toString().trim()
  hash2 = fs.readFileSync("#{REFS_DIR}/#{branch2}").toString().trim()

  ancestor = do ->
    ancestors = {}

    while hash1?.length > 0 or hash2?.length > 0
      if hash1?.length > 0
        return hash1 if ancestors[hash1]
        ancestors[hash1] = true

      if hash2?.length > 0
        return hash2 if ancestors[hash2]
        ancestors[hash2] = true

      if hash1?.length > 0
        commit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash1}").toString())
        hash1 = commit.parent

      if hash2?.length > 0
        commit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash2}").toString())
        hash2 = commit.parent

    return

  if ancestor?
    console.log ancestor
  else
    console.log 'No common ancestor!'
