# Vimtastic.coffee
# Author: Justin Hill
# Date: 7/16/13

class Vimtastic
	constructor: ->
		@browser = new BrowserManipulation
		@activeTab = @browser.activeTab().tab
		safari.application.addEventListener "message", @routeMessage, yes
		safari.application.addEventListener "activate", @activate, yes
		safari.application.addEventListener "deactivate", @deactivate, yes
		window.onkeydown += (e) ->
			console.log e.keyCode
	
	activate: (e) ->
		console.log "activating"
		console.log typeof(e.target)
		e.target.page.dispatchMessage "setActive", yes
	
	deactivate: (e) ->
		console.log "deactivating"
		console.log e.target
		e.target.page.dispatchMessage "setActive", no

	routeMessage: (e) =>
		console.log "hello!"
		console.log e
		if e.target is @activeTab
			switch e.name
				when "changeTab"
					@browser.changeTab(e.message)
	
		else
			console.log "invalid target"

window.vimtastic = new Vimtastic
