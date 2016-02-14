module.exports =
  config: {}
  init: () ->
    @config['meldPath'] = atom.config.get('atom-meld.meldPath')
    @config['meldArgs'] = atom.config.get('atom-meld.meldArgs')

    atom.config.onDidChange 'atom-meld.meldPath', () =>
      @init()

    atom.config.onDidChange 'atom-meld.meldArgs', () =>
      @init()
