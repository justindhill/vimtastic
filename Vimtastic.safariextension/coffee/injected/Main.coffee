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
		if isActive
			console.log "Vimtastic: registering..."
			document.addEventListener "keypress", @keyDispatch, no
		else
			console.log "Vimtastic: de-registering..."
			document.removeEventListener "keypress", @keyDispatch, no
		@active = isActive


	keyDispatch: (e) =>
		if @active
			if @mode is "normal" then @normalKeystroke(e)
			else if @mode is "insert" then @insertKeystroke(e)
			else if @mode is "command" then @commandKeystroke(e)
			else if @mode is "link" then @linkKeystroke

		return no

	normalKeystroke: (e) ->
		switch e.keyCode
			# J
			when 74
				e.preventDefault()
				safari.self.tab.dispatchMessage "changeTab", "left"

			# K
			when 75
				e.preventDefault()
				safari.self.tab.dispatchMessage "changeTab", "right"

			# j
			when 106
				e.preventDefault()
				window.scrollBy 0, 60

			# k
			when 107
				e.preventDefault()
				window.scrollBy 0, -60

			# d
			when 100
				e.preventDefault()
				window.scrollBy 0, window.innerHeight

			# b
			when 98
				e.preventDefault()
				window.scrollBy 0, -window.innerHeight

	insertKeystroke: (e) ->

	commandKeystroke: (e) ->

if window is window.top
	window.vimtastic = new VimtasticInjector
	safari.self.tab.dispatchMessage "log", "injected!"

