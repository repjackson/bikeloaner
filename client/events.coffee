FlowRouter.route '/events', action: ->
    BlazeLayout.render 'layout', 
        main: 'events'

Template.events.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'event')


Template.events.helpers
    events: -> Docs.find {type: 'event'}
            
    
    
Template.event_edit.events
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