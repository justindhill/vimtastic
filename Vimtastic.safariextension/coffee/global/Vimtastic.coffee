# Vimtastic.coffee
# Author: Justin Hill
# Date: 7/16/13

class Vimtastic
	constructor: ->
		@browser = new BrowserManipulation
		@activeTab = @browser.activeTab().tab
		safari.application.addEventListener "message", @routeMessage, yes
		safari.application.addEventListener "open", @activate, yes
		safari.application.addEventListener "navigate", @activate, yes
		safari.application.addEventListener "activate", @activate, yes
		safari.application.addEventListener "deactivate", @deactivate, yes
	
	activate: (e) ->
		console.log "activated"
		if e.target.page?
			e.target.page.dispatchMessage "setActive", yes
		else
			e.target.activeTab.page.dispatchMessage "setActive", yes
	
	deactivate: (e) ->
		if e.target.page?
			e.target.page.dispatchMessage "setActive", no
		else
			e.target.activeTab.page.dispatchMessage "setActive", no

	routeMessage: (e) =>
		switch e.name
			when "changeTab"
				@browser.changeTab(e.message)
			when "log"
				console.log "log: #{e.message}"

window.vimtastic = new Vimtastic
