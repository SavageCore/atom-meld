{CompositeDisposable} = require 'atom'
{TextEditor} = require 'atom'
module.exports = {
  init: ->
    @changePaneSubscription = atom.workspace.onDidStopChangingActivePaneItem((item) =>
      return unless item instanceof TextEditor
      @selectEntry(item)
    )

  selectEntry: (editor) ->
    return unless editor?
    return unless editor.buffer?
    file = editor.buffer.file
    return unless file?
    filePath = file.getPath()

    # Replace single backslash with double if platform win32
    if process.platform is 'win32'
      fileSelectorPath = filePath.split('\\').join('\\\\')
      fileSelector = '.tree-view [data-path="' + fileSelectorPath + '"]'
    else
      fileSelector = '.tree-view [data-path="' + filePath + '"]'
    entry = document.querySelector(fileSelector)

    # Perhaps a bug but both file.isSymbolicLink() and file.getParent().isSymbolicLink() always return false
    # and file.getPath(), file.getRealPathSync() only return resolved path
    # When base project folder is symlink
    # Example package in C:\Users\SavageCore\Documents\Git\atom-meld\ installed via `apm link`
    # file.getPath() returns C:\Users\SavageCore\Documents\Git\atom-meld\lib\watcher.coffee
    # But tree-view data-path is C:\Users\SavageCore\.atom\packages\atom-meld\lib\watcher.coffee
    # So to 'fix' we run the querySelector again based on relativizePath() if entry not set above

    if not entry
      relativePath = atom.project.relativizePath(filePath)
      if process.platform is 'win32'
        relativeSelectorPath = relativePath[0] + '\\' + relativePath[1]
        relativeSelectorPath = relativeSelectorPath.split('\\').join('\\\\')
      if process.platform is 'linux'
        relativeSelectorPath = relativePath[0] + '/' + relativePath[1]
      fileSelector = '.tree-view [data-path="' + relativeSelectorPath + '"]'
      entry = document.querySelector(fileSelector)

    return unless entry?

    selectedEntries = @getSelectedEntries()
    if entry and (selectedEntries.length > 1 or selectedEntries[0] isnt entry)
      @deselect(selectedEntries)
      entry.classList.add('am-active')

  getSelectedEntries: ->
    document.querySelectorAll('.tree-view .am-active')

  deselect: (elementsToDeselect=@getSelectedEntries()) ->
    selected.classList.remove('am-active') for selected in elementsToDeselect
    undefined

  destroy: ->
    @changePaneSubscription.dispose()
}
