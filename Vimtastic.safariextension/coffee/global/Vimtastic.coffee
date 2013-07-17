# Vimtastic.coffee
# Author: Justin Hill
# Date: 7/16/13

class Vimtastic
	constructor: ->
		@browser = new BrowserManipulation
		safari.application.addEventListener "message", message, no
		safari.application.addEventListener "activate", activate, no
	
	message: ->
		tabs = safari.application.activeBrowserWindow.tabs

		for i in [0..tabs.length - 1]
			safari.application.activeBrowserWindow.tabs[i].page.dispatchMessage 'setActive', no

	activate: ->

window.vimtastic = new Vimtastic
