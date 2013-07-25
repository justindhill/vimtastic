# VimtasticInjector.coffee
# Author: Justin Hill
# Date: 7/16/13

class VimtasticInjector
	constructor: ->
		@mode = "normal"
		@active = no
		@buffer = ""
		@window = new WindowManipulation

		@normalMap = [
			{ binding: /([0-9]*)j/, callback: @window.scrollDown }
			{ binding: /([0-9]*)k/, callback: @window.scrollUp }
			{ binding: /([0-9]*)h/, callback: @window.scrollLeft }
			{ binding: /([0-9]*)l/, callback: @window.scrollRight }
			{ binding: "J", callback: @window.tabLeft }
			{ binding: "K", callback: @window.tabRight }
			{ binding: "d", callback: @window.scrollPageDown }
			{ binding: "b", callback: @window.scrollPageUp }
			{ binding: "H", callback: @window.back }
			{ binding: "L", callback: @window.forward }
			{ binding: "r", callback: @window.refresh }
			{ binding: /gg/, callback: @window.scrollTop }
			{ binding: "G", callback: @window.scrollBottom }
		]
		safari.self.addEventListener "message", @globalDispatch, no
		console.log "Vimtastic!"


	globalDispatch: (e) =>
		switch e.name
			when "setActive" then @setActive(e.message)

	setActive: (isActive) ->
		if isActive
			# check for input element when tab is set active
			if document.activeElement.tagName is "INPUT"
				console.log "Vimtastic: active element is input tag, switching to insert mode"
				@mode = "insert"

			# register events
			console.log "Vimtastic: registering..."
			document.addEventListener "keypress", @keyDispatch, no
			document.body.addEventListener "focus", @focus, yes
			document.body.addEventListener "blur", @blur, yes
		else
			# reset mode
			@mode = "normal"

			# unregister events
			console.log "Vimtastic: de-registering..."
			document.removeEventListener "keypress", @keyDispatch, no
			document.body.removeEventListener "focus", @focus, yes
			document.body.removeEventListener "blur", @blur, yes

		@active = isActive


	keyDispatch: (e) =>
		if @active
			if @mode is "normal" then @normalKeystroke(e)
			else if @mode is "insert" then @insertKeystroke(e)
			else if @mode is "command" then @commandKeystroke(e)
			else if @mode is "link" then @linkKeystroke

		return no

	normalKeystroke: (e) ->

		char = String.fromCharCode(e.which)
		temp = @prefixModifier(e, @buffer + char)

		foundMatch = no
		for map in @normalMap
			switch map.binding.constructor.name
				when "RegExp"
					result = temp.match map.binding
					if result?
						if result[1] isnt ""
							map.callback(parseFloat(result[1])) 
						else map.callback()
						foundMatch = yes
						break
				when "String"
					if map.binding is temp
						map.callback()
						foundMatch = yes
						break

			if foundMatch 
				@buffer = ""
				e.preventDefault()
				break

		if not foundMatch
			@buffer += char

		console.log "#{@buffer}"
	
	insertKeystroke: (e) ->
		if e.keyCode is 27
			document.activeElement.blur()
			e.preventDefault()
	
	# event callbacks
	focus: (e) =>
		@mode = "insert"
		console.log @mode

	blur: =>
		@mode = "normal"
		console.log @mode
	commandKeystroke: (e) ->

	prefixModifier: (e, suffix) ->
		result = ""
		if e.ctrlKey
			result += "c-"
		else if e.altKey 
			result += "a-"
		else if e.metaKey
			result += "m-"

		result += suffix
	
if window is window.top
	window.vimtastic = new VimtasticInjector
	safari.self.tab.dispatchMessage "log", "injected!"

