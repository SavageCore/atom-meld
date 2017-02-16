# Atom Meld

![apm version][av] ![apm downloads][ad] [![Build Status](https://travis-ci.org/SavageCore/atom-meld.svg?branch=master)](https://travis-ci.org/SavageCore/atom-meld) [![Dependency Status](https://dependencyci.com/github/SavageCore/atom-meld/badge)](https://dependencyci.com/github/SavageCore/atom-meld)

Diff with external tool [Meld](http://meldmerge.org/)

Please send comments, [issues][issue], [bugs][issue], [feature requests][issue] and PRs!

![AM][preview-file-file]

![AM][preview-tab-active]

![AM][preview-tree-tab]

### Installation

Do one of the following

1. Run the command:
```sh
apm install atom-meld
```
2. Find the package in **Atom → Settings → Install** by searching for ***atom-meld***.

### Settings

###### Meld Arguments

Set [Command Line Arguments](http://manpages.ubuntu.com/manpages/precise/man1/meld.1.html) to pass to [Meld](http://meldmerge.org/). Default ` --auto-compare`

###### Meld Path

Default `meld`. For Windows either add [Meld](http://meldmerge.org/) to your PATH and use `meld` or input the full path `C:\Program Files (x86)\Meld\Meld.exe`

### Commands

|Command |Description|Keymap|
|---|---|---|
|atom-meld:diff-from-file-file|[Active File with File from System][preview-file-file]|alt-m|
|atom-meld:diff-from-file-tab|Active File with Open Tab|ctrl-alt-m/ctrl-cmd-m|
|atom-meld:diff-from-tab-active|[Selected Tab with Active File][preview-tab-active]||
|atom-meld:diff-from-tab-file|Selected Tab with File from System||
|atom-meld:diff-from-tab-tab|Selected Tab with Open Tab||
|atom-meld:diff-from-tree-active|Selected File from Tree View with Active File||
|atom-meld:diff-from-tree-file|Selected File from Tree View with File from System||
|atom-meld:diff-from-tree-tab|[Selected File from Tree View with Open Tab][preview-tree-tab]||
|atom-meld:diff-from-tree-selected|[Two Selected Files from Tree View][preview-tree-selected]||

### License
Atom Meld is released under the [MIT license][license].

[preview-file-file]:https://raw.githubusercontent.com/SavageCore/atom-meld/master/img/preview-file-file.gif "Diff Active File with File from System"
[preview-tab-active]:https://raw.githubusercontent.com/SavageCore/atom-meld/master/img/preview-tab-active.gif "Diff Selected Tab with Active File"
[preview-tree-tab]:https://raw.githubusercontent.com/SavageCore/atom-meld/master/img/preview-tree-tab.gif "Diff Selected File from Tree View with Open Tab"
[preview-tree-selected]:https://raw.githubusercontent.com/SavageCore/atom-meld/master/img/preview-tree-selected.gif "Diff Two Selected Files from Tree View"
[changelog]: https://github.com/SavageCore/atom-meld/blob/master/CHANGELOG.md
[issue]: https://github.com/SavageCore/atom-meld/issues
[license]: LICENSE.md
[ad]: https://img.shields.io/apm/dm/atom-meld.svg
[av]: https://img.shields.io/apm/v/atom-meld.svg
