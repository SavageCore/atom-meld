{CompositeDisposable} = require 'atom'
{TextEditor} = require 'atom'
module.exports = {
  init: ->
    @selectEntry(atom.workspace.getActiveTextEditor())

    @disposables = new CompositeDisposable
    @disposables.add atom.workspace.onDidChangeActivePaneItem (editor) =>
      if editor instanceof TextEditor
        @selectEntry(editor)

  selectEntry: (TextEditor) ->
    return unless TextEditor?
    filePath = TextEditor.getPath();
    # Replace single backslash with double if platform win32
    if process.platform is 'win32'
      filePath = filePath.split('\\').join('\\\\');
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
