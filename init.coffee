fs = require('fs')

MINIGIT_DIR = '.minigit'

module.exports = ->
  fs.mkdir MINIGIT_DIR, ->
    for dir in ['refs', 'objects']
      fs.mkdirSync "#{MINIGIT_DIR}/#{dir}"
    fs.writeFileSync "#{MINIGIT_DIR}/refs/master", ''
    fs.writeFileSync "#{MINIGIT_DIR}/HEAD", 'master'
    console.log "Initialized empty minigit repository in #{__dirname}/#{MINIGIT_DIR}/"
