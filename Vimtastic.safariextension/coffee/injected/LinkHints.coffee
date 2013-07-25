class LinkHints
	constructor: (@openNewTab = null, @navigate = null) ->
		@el = null
		@openInNewTab = no
		@hintMarkers = []

	enable: (options) ->
		if options?
			@openInNewTab = options.openInNewTab or no

		@generate()
		@render()

	disable: ->
		# remove link hints and stuff.
		document.body.removeChild @el

	hintChars: "sadfjklewcmpgh"

	generate: ->
		elements = @visibleClickableElements()
		hintLength = Math.ceil(@logXOfBase(elements.length, @hintChars.length))

		for i in [0..elements.length - 1]
			marker = new LinkHintMarker
				target: elements[i].el
				text: @generateHintString(i, hintLength)

			@hintMarkers.push marker

	render: ->
		container = document.createElement "div"
		container.className = "vimtastic-container"

		for marker in @hintMarkers
			container.appendChild marker.render().el

		document.body.appendChild container
		@el = container
		this

	keyPress: (e) ->
		return

	match: ->
		return
	remove: ->
		return

	visibleClickableElements: ->
		namespaceResolver = (namespace) -> if namespace is "xhtml" then "http://www.w3.org/1999/xhtml" else null
		result = document.evaluate @clickableXpath(), document.body, namespaceResolver, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null
		visible = []

		for i in [0..(result.snapshotLength - 1)]
			el = result.snapshotItem i
			clientRect = el.getClientRects()[0]

			if @isVisible(el, clientRect)
				visible.push el: el, rect: clientRect
		
			if clientRect and (clientRect.width is 0 or clientRect.height is 0)
				for j in [0..el.children.length - 1]
					child = el.children[j]
					if window.getComputedStyle(child, null).getPropertyValue('float') isnt 'none'
						childClientRect = child.getClientRects[0]
						if @isVisible(child, childClientRect)
							visible.push el: child, rect: childClientRect
							break;
		return visible

	isVisible: (el, rect) ->
		zoomLevel = document.documentElement.clientWidth / window.innerWidth
		if not rect or rect.top < 0 or rect.top * zoomLevel >= window.innerHeight - 4 or rect.left * zoomLevel >= window.innerWidth - 4
			return no

		if rect.width < 3 or rect.height < 3
			return no

		style = window.getComputedStyle(el, null)
		if style.getPropertyValue 'visibility' isnt 'visible' or style.getPropertyValue 'display' is 'none'
			return no

		return yes

	logXOfBase: (x, base) -> Math.log(x) / Math.log(base)

	# TODO: Make this suck less.
	generateHintString: (seed, hintLength) ->
		base = @hintChars.length
		hintString = []

		while hintString.length <= hintLength
			remainder = seed % base
			hintString.unshift @hintChars[remainder]
			seed -= remainder
			seed /= Math.floor base
  
		return hintString.join("")
 
	clickableXpath: ->
		clickable = ["a", "textarea", "button", "select", "input[not(@type='hidden')]"]

		xpath = [];
		for el in clickable
			xpath.push("//" + el, "//xhtml:" + el);
		xpath.push("//*[@onclick]");

		xpath.join(" | ")

class LinkHintMarker
	tagName: "div"
	className: "vimtastic-link-marker"

	constructor: (options) ->
		@el = document.createElement(@tagName)
		@el.className = @className
		if options?
			@target = options.target or null
			@text = options.text or ""

	render: ->
		@el.innerHTML = @text
		rect = @target.getClientRects()[0]
		@el.style.left = "#{rect.left}px"
		@el.style.top = "#{rect.top}px"
		#@target.innerHTML += @el.outerHTML

		this



window.LinkHints = LinkHints
