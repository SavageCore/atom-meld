#
# * atom-meld
# * https://github.com/SavageCore/atom-meld
# *
# * Copyright (c) 2016 SavageCore
# * Licensed under the MIT license.
#
{CompositeDisposable} = require 'event-kit'
AtomMeldExecutor = require './executor'
config = require('./config.coffee')

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
    @disposables = new CompositeDisposable
    unless @openFileSelectionView?
        OpenFileSelectionView = require './views/open-file-selection'
        @openFileSelectionView = new OpenFileSelectionView(state.openFileSelectionView)
    @openFileSelectionView

    @disposables.add atom.commands.add 'atom-text-editor', 'atom-meld:diff-from-file-tab', => @diff_from_file_tab()
    @disposables.add atom.commands.add('.tree-view', {
      'atom-meld:diff-from-tree-active': => @diff_from_tree_active()
      'atom-meld:diff-from-tree-tab': => @diff_from_tree_tab()
    })
    @disposables.add atom.commands.add('.tab-bar', {
      'atom-meld:diff-from-tab-active': => @diff_from_tab_active()
      'atom-meld:diff-from-tab-tab': => @diff_from_tab_tab()
    })

  diff_from_tree_active: ->
    packageObj = null
    activeFile = atom.workspace.getActiveTextEditor().getPath()
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObj = treeView.serialize()
    if typeof packageObj != 'undefined' && packageObj != null
      if packageObj.selectedPath
          sourceFile = packageObj.selectedPath
          targetFile = atom.workspace.getActiveTextEditor().getPath()
          AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tree_tab: ->
    packageObj = null
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObj = treeView.serialize()
    if typeof packageObj != 'undefined' && packageObj != null
      if packageObj.selectedPath
          global.sourceFile = packageObj.selectedPath
          @openFileSelectionView.show(null, false, packageObj.selectedPath)

  diff_from_tab_active: ->
      sourceFile = document.querySelector(".tab-bar .right-clicked .title").getAttribute('data-path');
      targetFile = atom.workspace.getActiveTextEditor().getPath()
      AtomMeldExecutor.runMeld(sourceFile, targetFile)

  diff_from_tab_tab: ->
    # todo
    atom.notifications.addWarning "atom-meld: Coming soon..."

  diff_from_file_tab: ->
    packageObj = null
    if atom.packages.isPackageLoaded('tree-view') == true
      treeView = atom.packages.getLoadedPackage('tree-view')
      treeView = require(treeView.mainModulePath)
      packageObj = treeView.serialize()
    if typeof packageObj != 'undefined' && packageObj != null
      if packageObj.selectedPath
          global.sourceFile = atom.workspace.getActiveTextEditor().getPath()
          targetFile = packageObj.selectedPath
          @openFileSelectionView.show(targetFile, true)

  deactivate: ->
    @openFileSelectionView.destroy()
    @disposables.dispose()

  serialize: ->
    openFileSelectionViewState: @openFileSelectionView.serialize()
