fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

module.exports = (branch) ->
  head = fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()
  hash1 = fs.readFileSync("#{REFS_DIR}/#{head}").toString().trim()
  hash2 = fs.readFileSync("#{REFS_DIR}/#{branch}").toString().trim()

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
    ancestorCommit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{ancestor}").toString())
    hash1 = fs.readFileSync("#{REFS_DIR}/#{head}").toString().trim()
    hash2 = fs.readFileSync("#{REFS_DIR}/#{branch}").toString().trim()
    commit1 = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash1}").toString())
    commit2 = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash2}").toString())

    files = {}
    for { file, hash } in ancestorCommit.files
      files[file] ?= {}
      files[file].ancestor = hash
    for { file, hash } in commit1.files
      files[file] ?= {}
      files[file].local = hash
    for { file, hash } in commit2.files
      files[file] ?= {}
      files[file].merging = hash

    resolutions = {}
    conflicts = []
    for file, { ancestor, local, merging } of files
      if local? or merging?
        if local is merging
          resolutions[file] = local
        else if merging is ancestor
          resolutions[file] = local if local?
        else if local is ancestor
          resolutions[file] = merging if merging?
        else
          conflicts.push file

    if conflicts.length > 0
      console.log 'Conflicts:'
      for conflict in conflicts
        console.log "  #{conflict}"
      return

    fs.readdir '.', (err, files) ->
      return if err?

      for file in files when not fs.statSync(file).isDirectory()
        fs.unlinkSync(file)

      for file, hash of resolutions
        data = fs.readFileSync("#{OBJECTS_DIR}/#{hash}")
        fs.writeFileSync file, data

      console.log "Merged #{branch} into #{head}"
