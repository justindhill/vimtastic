# Inject the required script files

class VimtasticInjector
	constructor: ->
		console.log "Vimtastic!"

		document.addEventListener "keydown", @keyDispatch, no
		safari.self.addEventListener "message", @globalDispatch, no

		@mode = "normal"
		@active = no

	globalDispatch: (e) =>
		switch e.name
			when "setActive" then @setActive(e.message)

	setActive: (isActive) ->
		console.log isActive
		@active = isActive

	keyDispatch: (e) =>
		console.log e
		console.log @active
		if @active
			if @mode is "normal" then @normalKeystroke(e)
			else if @mode is "insert" then @insertKeystroke(e)
			else if @mode is "command" then @commandKeystroke(e)

		return no

	normalKeystroke: (e) ->
		if e.keyCode is 74
			console.log "go left"
			safari.self.tab.dispatchMessage "changeTab", "left"

	insertKeystroke: (e) ->

	commandKeystroke: (e) ->
if window is window.top
	window.vimtastic = new VimtasticInjector
