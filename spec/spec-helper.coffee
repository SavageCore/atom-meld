module.exports =
  # Credit: https://github.com/lee-dohm/tabs-to-spaces/blob/9669f70b1b0a917f501a4bc4bc3bcba284e0962d/spec/spec-helper.coffee
  # Public: Indicates whether an element has a command.
  #
  # * `element` An {HTMLElement} to search.
  # * `name` A {String} containing the command name.
  #
  # Returns a {Boolean} indicating if it has the given command.
  hasCommand: (element, name) ->
    found = false
    commands = atom.commands.findCommands(target: element)
    (found = true) for command in commands when command.name is name

    found
