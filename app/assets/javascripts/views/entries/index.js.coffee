class Raffler.Views.EntriesIndex extends Backbone.View
	template: JST['entries/index']
	
	events:
		'submit #new_entry' : 'createEntry'
		'click #draw': 'drawWinner'
	
	initialize: ->
		@collection.on('reset', @render, this)
		@collection.on('add', @appendEntry, this)
	
	render: ->
		$(@el).html(@template())
		@collection.each(@appendEntry, this)
		this
		
	appendEntry: (entry) ->
		view = new Raffler.Views.Entry(model: entry)
		@$('#entries').append(view.render().el)
		
	createEntry: (event) ->
		event.preventDefault()
		attributes = name: $('#new_entry_name').val()
		@collection.create attributes,
			wait: true
			success: -> $('#new_entry')[0].reset()
			error: @handleError
	
	drawWinner: (event) ->
		event.preventDefault()
		@collection.drawWinner()
	
	handleError: (entry, response) ->
		alert response.responseText
		if response.status == 422
			errors = $.parseJSON(response.responseText)
			for attribute, messages of errors
				alert "#{attribute} #{message}" for message in messages
				