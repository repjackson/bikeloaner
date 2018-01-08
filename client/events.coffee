FlowRouter.route '/events', action: ->
    BlazeLayout.render 'layout', 
        main: 'events'

Template.events.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'event')


Template.events.helpers
    events: -> Docs.find {type: 'event'}
            
Template.events.events
    'click #add_event': ->
        id = Docs.insert
            type: 'event'
        FlowRouter.go "/event/#{id}"
        Session.set 'editing', true
        
        
FlowRouter.route '/event/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'event'

Template.event.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.event.helpers
    event: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.event.events
    'click #delete': ->
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            event = Docs.findOne FlowRouter.getParam('events_id')
            Docs.remove event._id, ->
                FlowRouter.go "/events"        