fs = require 'fs'
path = require 'path'
temp = require 'temp'
{$, $$} = require 'atom-space-pen-views'
fs = require 'fs-plus'

helper = require './spec-helper'

describe "waiting for package to load", ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('atom-meld')

  it 'should have waited long enough', ->
    expect(atom.packages.isPackageActive('atom-meld')).toBe true

describe "package activate", ->
  [rootDirPath, textEditorElement, tabBarElement, treeViewElement, treeViewMultiSelectElement, workspaceElement] = []

  beforeEach ->
    rootDirPath = fs.absolute(temp.mkdirSync('atom-meld'))
    dirPath = path.join(rootDirPath, "test-dir")

    filePath1 = path.join(dirPath, 'atom-meld-1.txt')
    filePath2 = path.join(dirPath, 'atom-meld-2.txt')
    fs.writeFileSync(filePath1, '')
    fs.writeFileSync(filePath2, '')

    atom.project.setPaths([rootDirPath])

    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.workspace.open(filePath1).then (e) ->
        textEditorElement = atom.views.getView(e)

    waitsForPromise ->
      atom.packages.activatePackage('atom-meld')

    waitsForPromise ->
      atom.packages.activatePackage('tabs').then (e) ->
        tabBarElement = workspaceElement.querySelector('.tab-bar')

    waitsForPromise ->
      atom.packages.activatePackage('tree-view').then () ->
        atom.commands.dispatch(workspaceElement, 'tree-view:toggle')
        treeView = $(atom.workspace.getLeftPanels()[0].getItem()).view()
        treeViewElement = workspaceElement.querySelector('.tree-view')

        dirView = $(treeView.roots[0].entries).find('.directory:contains(test-dir)')
        dirView[0].expand()

        fileView1 = treeView.find('.file:contains(atom-meld-1.txt)')
        fileView2 = treeView.find('.file:contains(atom-meld-2.txt)')

        fileView1.click()
        fileView2.trigger($.Event('mousedown', {shiftKey: true}))

        treeViewMultiSelectElement = workspaceElement.querySelector('.tree-view.multi-select')

  it 'creates the commands', ->
    expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-file')).toBe true
    expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-tab')).toBe true
    expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-active')).toBe true
    expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-file')).toBe true
    expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-tab')).toBe true
    expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-active')).toBe true
    expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-file')).toBe true
    expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-tab')).toBe true
    expect(helper.hasCommand(treeViewMultiSelectElement, 'atom-meld:diff-from-tree-selected')).toBe true

describe 'package deactivate', ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.disablePackage('atom-meld')

    it 'destroys the commands', ->
      expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-file')).toBe false
      expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-tab')).toBe false
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-active')).toBe false
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-file')).toBe false
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-tab')).toBe false
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-active')).toBe false
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-file')).toBe false
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-tab')).toBe false
      expect(helper.hasCommand(treeViewMultiSelectElement, 'atom-meld:diff-from-tree-selected')).toBe false
