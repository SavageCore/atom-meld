fs = require 'fs'
path = require 'path'
temp = require 'temp'
{$, $$} = require 'atom-space-pen-views'
fs = require 'fs-plus'

helper = require './spec-helper'

describe "Atom Meld", ->
  [workspaceElement] = []
  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)

    waitsForPromise ->
      atom.packages.activatePackage('atom-meld')

  it 'activated', ->
    expect(atom.packages.isPackageActive('atom-meld')).toBe true

  describe "select multiple files in tree view", ->
    [fileView1, treeViewMultiSelectElement] = []

    beforeEach ->
      createFiles()

      waitsForPromise ->
        atom.packages.activatePackage('tree-view').then () ->
          fileViews = openTreeView(workspaceElement)
          fileView1 = fileViews[0]
          fileView2 = fileViews[1]

          fileView1.click()
          fileView2.trigger($.Event('mousedown', {shiftKey: true} ))

          treeViewMultiSelectElement = workspaceElement.querySelector('.tree-view.multi-select')

    it 'has command: atom-meld:diff-from-tree-selected', ->
      expect(helper.hasCommand(treeViewMultiSelectElement, 'atom-meld:diff-from-tree-selected')).toBe true

    it 'has context menu item: Diff Selected Files', ->
      expect(atom.contextMenu.templateForElement(fileView1[0])[0].submenu).toEqual([
        { label : 'Diff Selected Files', command : 'atom-meld:diff-from-tree-selected' }
      ])

  describe "select active file in tree view", ->
    [singleSelectElement] = []

    beforeEach ->
      filePath1 = createFiles()[0]

      waitsForPromise ->
        atom.workspace.open(filePath1)

      waitsForPromise ->
        atom.packages.activatePackage('tree-view').then () ->
          fileViews = openTreeView(workspaceElement)
          fileView1 = fileViews[0]

          fileView1.click()
          singleSelectElement = workspaceElement.querySelector('.tree-view > :not(.multi-select) .file.selected > .name')
          singleSelectElement.className += ' am-active'

    it 'has command: atom-meld:diff-from-tree-active', ->
      expect(helper.hasCommand(singleSelectElement, 'atom-meld:diff-from-tree-active')).toBe true

    it 'has command: atom-meld:diff-from-tree-file', ->
      expect(helper.hasCommand(singleSelectElement, 'atom-meld:diff-from-tree-file')).toBe true

    it 'has command: atom-meld:diff-from-tree-tab', ->
      expect(helper.hasCommand(singleSelectElement, 'atom-meld:diff-from-tree-tab')).toBe true

    it 'has context menu items: Diff with Open Tab, Diff with File', ->
      expect(atom.contextMenu.templateForElement(singleSelectElement)[0].submenu).toEqual([
        { label : 'Diff with Open Tab', command : 'atom-meld:diff-from-tree-tab' },
        { label : 'Diff with File', command : 'atom-meld:diff-from-tree-file' }
      ])

  describe "select non active file in tree view", ->
    [fileView2, treeViewElement] = []

    beforeEach ->
      filePath1 = createFiles()[0]

      waitsForPromise ->
        atom.workspace.open(filePath1)

      waitsForPromise ->
        atom.packages.activatePackage('tree-view').then () ->
          fileViews = openTreeView(workspaceElement)
          fileView2 = fileViews[1]
          treeViewElement = fileViews[2]

    it 'has command: atom-meld:diff-from-tree-active', ->
      # TODO: This should be false, look at changing
      # @commands.add atom.commands.add '.tree-view',
      # in atom-meld.coffee
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-active')).toBe true

    it 'has command: atom-meld:diff-from-tree-file', ->
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-file')).toBe true

    it 'has command: atom-meld:diff-from-tree-tab', ->
      expect(helper.hasCommand(treeViewElement, 'atom-meld:diff-from-tree-tab')).toBe true

    it 'has context menu items: Diff with Active File, Diff with Open Tab, Diff with File', ->
      fileView2.click()
      singleSelectElement = workspaceElement.querySelector('.tree-view:not(.multi-select) .file.selected > .name:not(.am-active)')

      expect(atom.contextMenu.templateForElement(singleSelectElement)[0].submenu).toEqual([
        { label : 'Diff with Active File', command : 'atom-meld:diff-from-tree-active' },
        { label : 'Diff with Open Tab', command : 'atom-meld:diff-from-tree-tab' },
        { label : 'Diff with File', command : 'atom-meld:diff-from-tree-file' }
      ])

  describe "select active tab", ->
    [fileView1, tabBarElement] = []

    beforeEach ->
      filePaths = createFiles()
      filePath1 = filePaths[0]
      filePath2 = filePaths[1]

      waitsForPromise ->
        atom.workspace.open(filePath2)

      waitsForPromise ->
        atom.workspace.open(filePath1)

      waitsForPromise ->
        atom.packages.activatePackage('tabs').then () ->
          tabBarElement = atom.views.getView(atom.workspace).querySelectorAll('.tab.active')[0]
          fileView1 = tabBarElement

    it 'has command: atom-meld:diff-from-tab-active', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-active')).toBe true

    it 'has command: atom-meld:diff-from-tab-file', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-file')).toBe true

    it 'has command: atom-meld:diff-from-tab-tab', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-tab')).toBe true

    it 'has context menu items: Diff with File, Diff with Open Tab', ->
      fileView1.click()
      expect(atom.contextMenu.templateForElement(fileView1)[0].submenu).toEqual([
        { label : 'Diff with File', command : 'atom-meld:diff-from-tab-file' },
        { label : 'Diff with Open Tab', command : 'atom-meld:diff-from-tab-tab' }
      ])

  describe "select non active tab", ->
    [fileView2, tabBarElement] = []

    beforeEach ->
      filePaths = createFiles()
      filePath1 = filePaths[0]
      filePath2 = filePaths[1]

      waitsForPromise ->
        atom.workspace.open(filePath2)

      waitsForPromise ->
        atom.workspace.open(filePath1)

      waitsForPromise ->
        atom.packages.activatePackage('tabs').then () ->
          tabBarElement = atom.views.getView(atom.workspace).querySelectorAll('.tab:not(.active)')[0]
          fileView2 = tabBarElement

    # TODO: This should be false, look at changing
    # @commands.add atom.commands.add '.tab-bar',
    # in atom-meld.coffee
    it 'has command: atom-meld:diff-from-tab-active', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-active')).toBe true

    it 'has command: atom-meld:diff-from-tab-file', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-file')).toBe true

    it 'has command: atom-meld:diff-from-tab-tab', ->
      expect(helper.hasCommand(tabBarElement, 'atom-meld:diff-from-tab-tab')).toBe true

    it 'has context menu items: Diff with Active File, Diff with File, Diff with Open Tab', ->
      fileView2.click()

      expect(atom.contextMenu.templateForElement(fileView2)[0].submenu).toEqual([
        { label : 'Diff with Active File', command : 'atom-meld:diff-from-tab-active' },
        { label : 'Diff with File', command : 'atom-meld:diff-from-tab-file' },
        { label : 'Diff with Open Tab', command : 'atom-meld:diff-from-tab-tab' }
      ])

  describe "right click within file", ->
    [textEditorElement] = []

    beforeEach ->
      filePaths = createFiles()
      filePath1 = filePaths[0]

      waitsForPromise ->
        atom.workspace.open(filePath1).then () ->
          editor = atom.workspace.getActivePaneItem()
          file = editor?.buffer?.file
          textEditorElement = workspaceElement.querySelector('atom-workspace atom-text-editor:not(.mini)')

    it 'has command: atom-meld:diff-from-file-file', ->
      expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-file')).toBe true

    it 'has command: atom-meld:diff-from-file-tab', ->
      expect(helper.hasCommand(textEditorElement, 'atom-meld:diff-from-file-tab')).toBe true

    it 'has context menu items: Diff with File, Diff with Open Tab', ->
      expect(atom.contextMenu.templateForElement(textEditorElement)[0].submenu).toEqual([
        { label: 'Diff with File', command: 'atom-meld:diff-from-file-file' },
        { label: 'Diff with Open Tab', command: 'atom-meld:diff-from-file-tab' }
      ])

describe 'deactivate', ->
  [workspaceElement] = []
  beforeEach ->
    atom.packages.disablePackage('atom-meld')
    workspaceElement = atom.views.getView(atom.workspace)

  it 'deactivated', ->
    expect(atom.packages.isPackageActive('atom-meld')).toBe false

  it 'destroys the commands', ->
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-file-file')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-file-tab')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tab-active')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tab-file')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tab-tab')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tree-active')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tree-file')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tree-tab')).toBe false
    expect(helper.hasCommand(workspaceElement, 'atom-meld:diff-from-tree-selected')).toBe false

###
  * [createFiles Create 2 dummy files and set project path to their dir]
  * @return {object} filePath1, filePath2
###
createFiles = ->
  rootDirPath = fs.absolute(temp.mkdirSync('atom-meld'))
  dirPath = path.join(rootDirPath, "test-dir")

  filePath1 = path.join(dirPath, 'atom-meld-1.txt')
  fs.writeFileSync(filePath1, '')
  filePath2 = path.join(dirPath, 'atom-meld-2.txt')
  fs.writeFileSync(filePath2, '')

  atom.project.setPaths([rootDirPath])

  return [filePath1, filePath2]

###
  * [activeFile Return filename of active file]
  * @return {string} Active filename
###
activeFile = ->
  editor = atom.workspace.getActivePaneItem()
  file = editor?.buffer?.file
  return file?.getBaseName()

###
 * [openTreeView description]
 * @param  {element} workspaceElement
 * @return {object} [fileView1, fileView2, treeViewElement]
###
openTreeView = (workspaceElement) ->
  atom.commands.dispatch(workspaceElement, 'tree-view:show')
  treeView = $(atom.workspace.getLeftDock().getActivePaneItem())[0]
  treeViewElement = workspaceElement.querySelector('.tree-view')

  dirView = $(treeView.roots[0].entries).find('.directory:contains(test-dir)')
  dirView[0].expand()

  files = treeView.element.querySelectorAll('.file')

  fileView1 = files[0]
  fileView2 = files[1]

  return [fileView1, fileView2, treeViewElement]
