# VimtasticInjector.coffee
# Author: Justin Hill
# Date: 7/16/13
#
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

	
		inputs = document.getElementsByTagName "input"
		if isActive
			console.log "Vimtastic: registering..."
			document.addEventListener "keydown", @keyDispatch, no
			for input in inputs
				input.addEventListener "focus", @focus
				input.addEventListener "blur", @blur

		else
			console.log "Vimtastic: de-registering..."
			document.removeEventListener "keydown", @keyDispatch, no
			for input in inputs
				input.removeEventListener "focus", @focus
				input.removeEventListener "blur", @blur

		@active = isActive


	keyDispatch: (e) =>
		if @active
			if @mode is "normal" then @normalKeystroke(e)
			else if @mode is "insert" then @insertKeystroke(e)
			else if @mode is "command" then @commandKeystroke(e)
			else if @mode is "link" then @linkKeystroke

		return no

	normalKeystroke: (e) ->
		# J
		if e.keyCode is 74 and e.shiftKey
			e.preventDefault()
			safari.self.tab.dispatchMessage "changeTab", "left"

		# K
		else if e.keyCode is 75 and e.shiftKey
			e.preventDefault()
			safari.self.tab.dispatchMessage "changeTab", "right"

		# j
		else if e.keyCode is 74
			e.preventDefault()
			window.scrollBy 0, 60

		# k
		else if e.keyCode is 75
			e.preventDefault()
			window.scrollBy 0, -60

		# d
		else if e.keyCode is 68
			e.preventDefault()
			window.scrollBy 0, window.innerHeight

		# b
		else if e.keyCode is 66
			e.preventDefault()
			window.scrollBy 0, -window.innerHeight

	insertKeystroke: (e) ->
		console.log e
		if e.keyCode is 27
			document.activeElement.blur()
			e.preventDefault()
		console.log e.keyCode
	
	# event callbacks
	focus: =>
		@mode = "insert"
		console.log @mode

	blur: =>
		@mode = "normal"
		console.log @mode
commandKeystroke: (e) ->

if window is window.top
	window.vimtastic = new VimtasticInjector
	safari.self.tab.dispatchMessage "log", "injected!"

