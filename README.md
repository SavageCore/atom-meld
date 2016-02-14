# Atom Meld

![apm version][av] ![apm downloads][ad]

Diff with external tool [Meld](http://meldmerge.org/)

Please send comments, [issues][issue], [bugs][issue], [feature requests][issue] and PRs!

![AM][preview]

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

Default `meld` for most Linux OSes. For Windows either add [Meld](http://meldmerge.org/) to your PATH and use `meld` or input the full path `C:\Program Files (x86)\Meld\Meld.exe`

### Features

* Context menu in tree-view (left side file list), tab-bar and active file.
* Diff with Open Tab
* Diff with Active File

### Planned Features

* Diff with File in Project

## License
Atom Meld is released under the [MIT license][license].

<!-- [preview]: https://raw.githubusercontent.com/SavageCore/atom-meld/master/img/preview.png -->
[preview]: http://i.imgur.com/iahtaGB.png
[changelog]: https://github.com/SavageCore/atom-meld/blob/master/CHANGELOG.md
[issue]: https://github.com/SavageCore/atom-meld/issues
[license]: LICENSE.md
[ad]: https://img.shields.io/apm/dm/atom-meld.svg
[av]: https://img.shields.io/apm/v/atom-meld.svg
