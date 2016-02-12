{BufferedProcess} = require 'atom'

module.exports = {
  runMeld: (sourceFile,targetFile) ->
      if(sourceFile == targetFile)
        atom.notifications.addWarning "atom-meld: You cannot diff the same file!"
        return true

      command = global.meldpath
      args = [sourceFile, targetFile, global.meldopts]
      stdout = (output) -> console.log(output)
      exit = (code) -> console.log("exited with #{code}")
      process = new BufferedProcess({command, args, stdout, exit})
      console.log("#{command} #{args}")
}
