{CompositeDisposable} = require 'atom'

module.exports = KeyboardLayout =
  subscriptions: null
  temporalSubscriptions: null
  active: false
  layout: {}

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'keyboard-layout:toggle': => @toggle()

    @layout =
      "1": "!"
      "2": "@"
      "3": "#"
      "4": "$"
      "5": "%"
      "6": "^"
      "7": "&"
      "8": "*"
      "9": "("
      "0": ")"

  deactivate: ->
    @temporalSubscriptions.dispose() if @temporalSubscriptions
    @subscriptions.dispose()

  toggle: ->
    @temporalSubscriptions.dispose() if @temporalSubscriptions
    if not @active
      @temporalSubscriptions = new CompositeDisposable
      @temporalSubscriptions.add atom.workspace.observeTextEditors (editor) =>
        @temporalSubscriptions.add editor.onWillInsertText (event) =>
          key = event.text
          if @layout.hasOwnProperty(key)
            event.cancel()
            editor.insertText @layout[key]
      @active = true
      atom.notifications.addSuccess "Keyboard layout is active"
    else
      @active = false
      atom.notifications.addInfo "Keyboard layout is inactive"
