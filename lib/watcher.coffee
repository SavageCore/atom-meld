{CompositeDisposable} = require 'atom'
module.exports = {
  init: ->
    @selectEntry(atom.workspace.getActiveTextEditor())

    @disposables = new CompositeDisposable
    @disposables.add atom.workspace.onDidChangeActivePaneItem (TextEditor) =>
      # Skip Settings page
      if TextEditor.uri == 'undefined'
        @selectEntry(TextEditor)

  selectEntry: (TextEditor) ->
    return unless TextEditor?
    filePath =  TextEditor.getPath().split('\\').join('\\\\');
    fileSelector = '.tree-view [data-path="' + filePath + '"]'

    entry = document.querySelector(fileSelector)

    selectedEntries = @getSelectedEntries()
    if entry and (selectedEntries.length > 1 or selectedEntries[0] isnt entry)
      @deselect(selectedEntries)
      entry.classList.add('am-active')
    entry

  getSelectedEntries: ->
    document.querySelectorAll('.tree-view .am-active')

  deselect: (elementsToDeselect=@getSelectedEntries()) ->
    selected.classList.remove('am-active') for selected in elementsToDeselect
    undefined

  destroy: ->
    @disposables.dispose()
}
