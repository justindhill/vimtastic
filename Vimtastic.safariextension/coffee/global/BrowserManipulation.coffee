# BrowserManipulation.coffee
# Author: Justin Hill
# Date: 7/16/13

class window.BrowserManipulation

	activeTab: ->
		tab: safari.application.activeBrowserWindow.activeTab
		index: safari.application.activeBrowserWindow.tabs.indexOf(
			safari.application.activeBrowserWindow.activeTab
		)

	changeTab: (direction) ->
		console.log "changeTab: #{direction}"
		t = @activeTab()
		tabs = safari.application.activeBrowserWindow.tabs

		if direction is "left"
			if t.index is 0
				tabs[tabs.length - 1].activate()
			else
				tabs[t.index - 1].activate()

		else if direction is "right"
			if t.index is tabs.length - 1
				tabs[0].activate()
			else
				tabs[t.index + 1].activate()
		
	
