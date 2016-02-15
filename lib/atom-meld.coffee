#
# * atom-meld
# * https://github.com/SavageCore/atom-meld
# *
# * Copyright (c) 2016 SavageCore
# * Licensed under the MIT license.
#
{CompositeDisposable} = require 'atom'
AtomMeldExecutor = require './executor'
config = require('./config.coffee')
watcher = require('./watcher.coffee')
{$} = require('atom-space-pen-views')
remote = require "remote"
dialog = remote.require "dialog"

module.exports = Atommeld =
  OpenFileSelectionView: null

  config:
      meldPath:
        title: 'Meld Path'
        description: 'Path to Meld executable'
        type: 'string'
        default: 'meld'
      meldArgs:
        title: 'Meld Arguments'
        description: 'Additional command-line options to pass to Meld'
        type: 'string'
        default: '--auto-compare'

  activate: (state) ->
    config.init()
    # Wait until document.onload
    $ ->
      watcher.init()

    @disposables = new CompositeDisposable
    unless @openFileSelectionView?
        OpenFileSelectionView = require './views/open-file-selection'
        @openFileSelectionView = new OpenFileSelectionView(state.openFileSelectionView)
    @openFileSelectionView

    @disposables.add atom.commands.add('atom-text-editor', {
      'atom-meld:diff-from-file-file': => @diff_from_file_file()
      'atom-meld:diff-from-file-tab': => @diff_from_file_tab()
    })
    @disposables.add atom.commands.add('.tab-bar', {
      'atom-meld:diff-from-tab-active': => @diff_from_tab_active()
      'atom-meld:diff-from-tab-file': => @diff_from_tab_file()
      'atom-meld:diff-from-tab-tab': => @diff_from_tab_tab()
    })
    @disposables.add atom.commands.add('.tree-view', {
      'atom-meld:diff-from-tree-active': => @diff_from_tree_active()
      'atom-meld:diff-from-tree-file': => @diff_from_tree_file()
      'atom-meld:diff-from-tree-tab': => @diff_from_tree_tab()
    })
    @disposables.add atom.commands.add '.tree-view.multi-select', 'atom-meld:diff-from-tree-selected', => @diff_from_tree_selected()

  diff_from_file_file: ->
    sourceFile = atom.workspace.getActiveTextEditor().getPath()
    targetFile = dialog.showOpenDialog({properties:['openFile'],defaultPath:atom.project.getPaths()[0]})
    return unless targetFile != undefined
    AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_file_tab: ->
    sourceFile = atom.workspace.getActiveTextEditor().getPath()
    targetFile = @getSelectedTree()
    @openFileSelectionView.show(sourceFile, true)

  diff_from_tab_active: ->
      sourceFile = document.querySelector(".tab-bar .right-clicked .title").getAttribute('data-path');
      targetFile = atom.workspace.getActiveTextEditor().getPath()
      AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tab_file: ->
    sourceFile = document.querySelector(".tab-bar .right-clicked .title").getAttribute('data-path');
    targetFile = dialog.showOpenDialog({properties:['openFile'],defaultPath:atom.project.getPaths()[0]})
    return unless targetFile != undefined
    AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tab_tab: ->
    sourceFile = document.querySelector(".tab-bar .right-clicked .title").getAttribute('data-path');
    @openFileSelectionView.show(sourceFile, false, sourceFile)

  diff_from_tree_active: ->
    sourceFile = @getSelectedTree()
    targetFile = atom.workspace.getActiveTextEditor().getPath()
    AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tree_file: ->
    sourceFile = @getSelectedTree()
    targetFile = dialog.showOpenDialog({properties:['openFile'],defaultPath:atom.project.getPaths()[0]})
    return unless targetFile != undefined
    AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tree_selected: ->
    selectedFilePaths = null
    treeViewPackage = atom.packages.getActivePackage('tree-view')
    if (treeViewPackage)
      selectedFilePaths = treeViewPackage.mainModule.treeView.selectedPaths();
      if (selectedFilePaths.length != 2)
        atom.notifications.addWarning 'Atom Meld: You must select 2 files to compare in the tree view'
        return true
    AtomMeldExecutor.runMeld(selectedFilePaths[0], selectedFilePaths[1])

  diff_from_tree_tab: ->
    global.sourceFile = @getSelectedTree()
    @openFileSelectionView.show(sourceFile, false, sourceFile)

  getSelectedTree: ->
    treeViewObj = null
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      treeViewObj = treeView.serialize()
    if typeof treeViewObj != 'undefined' && treeViewObj != null
      if treeViewObj.selectedPath
          sourceFile = treeViewObj.selectedPath
    return sourceFile

  deactivate: ->
    @openFileSelectionView.destroy()
    @disposables.dispose()

  serialize: ->
    openFileSelectionViewState: @openFileSelectionView.serialize()
