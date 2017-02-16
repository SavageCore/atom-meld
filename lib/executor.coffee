{BufferedProcess} = require 'atom'

module.exports = {
  runMeld: (sourceFile,targetFile) ->
    if(sourceFile == targetFile)
      atom.notifications.addWarning "atom-meld: You cannot diff the same file!"
      return true
      
    command = atom.config.get("atom-meld.meldPath")
    args = [sourceFile, targetFile, atom.config.get("atom-meld.meldArgs")]
    process = new BufferedProcess({command, args})
}
