# Inject the required script files

class VimtasticInjector
	constructor: ->
		console.log "Vimtastic!"

		safari.self.addEventListener "message", @globalDispatch, no

		@mode = "normal"
		@active = no

	globalDispatch: (e) =>
		switch e.name
			when "setActive" then @setActive(e.message)

	setActive: (isActive) ->
		console.log isActive
		if isActive
			console.log "registering..."
			document.addEventListener "keydown", @keyDispatch, no
		else
			console.log "de-registering..."
			document.removeEventListener "keydown", @keyDispatch, no
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

		else if e.keyCode is 75
			console.log "go right"
			safari.self.tab.dispatchMessage "changeTab", "right"

	insertKeystroke: (e) ->

	commandKeystroke: (e) ->
if window is window.top
	window.vimtastic = new VimtasticInjector
