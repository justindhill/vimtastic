# BrowserManipulation.coffee
# Author: Justin Hill
# Date: 7/16/13

class BrowserManipulation

	activeTabInfo: ->
		activeTab: safari.application.activeBrowserWindow.activeTab
		activeTabIndex: safari.application.activeBrowserWindow.tabs.indexOf(
			safari.application.activeBrowserWindow.activeTab
		)

	changeTab: (direction) ->
		t = @activeTabInfo()
		tabs = safari.application.activeBrowserWindow.tabs

		if direction is "left"
			if t.activeTabIndex is 0
				tabs[tabs.length - 1].activate()
			else
				tabs[t.activeTabIndex - 1].activate()

		else if direction is "right"
			if t.activeTabIndex is tabs.length - 1
				t[0].activate()
			else
				tabs[t.activeTabIndex + 1].activate()
		
	
