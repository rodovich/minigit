fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

module.exports = (branch) ->
  head = branch ? fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()
  hash = fs.readFileSync("#{REFS_DIR}/#{head}").toString().trim()

  while hash?.length > 0
    commit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash}").toString())
    console.log """
    commit #{hash}
    date:  #{commit.date}
    #{commit.message}

    """
    hash = commit.parent

  return
