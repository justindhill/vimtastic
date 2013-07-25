# WindowManipulation.coffee
# Author: Justin Hill
# Date: 7/17/13

class WindowManipulation
	scrollDown: (multiplier = 1) ->
		window.scrollBy 0, (60 * multiplier)

	scrollUp: (multiplier = 1) ->
		window.scrollBy 0, (-60 * multiplier)

	scrollLeft: (multiplier = 1) ->
		window.scrollBy (-60 * multiplier), 0

	scrollRight: (multiplier = 1) ->
		window.scrollBy (60 * multiplier), 0

	scrollPageDown: (multiplier = 1) ->
		window.scrollBy 0, (window.innerHeight * multiplier)

	scrollPageUp: (multiplier = 1) ->
		window.scrollBy 0, (-window.innerHeight * multiplier)

	scrollTop: ->
		window.scrollTo 0, 0

	scrollBottom: ->
		window.scrollTo 0, document.height

	tabLeft: ->
		safari.self.tab.dispatchMessage "changeTab", "left"
	
	tabRight: ->
		safari.self.tab.dispatchMessage "changeTab", "right"

	back: ->
		history.back()

	forward: ->
		history.forward()

	refresh: ->
		location.reload()

window.WindowManipulation = WindowManipulation
