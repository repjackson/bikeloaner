FlowRouter.route '/bikes', action: ->
    BlazeLayout.render 'layout', 
        main: 'bikes'

Template.bikes.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'bike')


Template.bikes.helpers
    bikes: -> Docs.find {type: 'bike'}
            
Template.bikes.events
    'click #add_bike': ->
        id = Docs.insert
            type: 'bike'
        FlowRouter.go "/bike/#{id}"
        Session.set 'editing', true
        
        
FlowRouter.route '/bike/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'bike'



Template.bike.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.bike.helpers
    bike: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.bike.events
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
            bike = Docs.findOne FlowRouter.getParam('bikes_id')
            Docs.remove bike._id, ->
                FlowRouter.go "/bikes"        