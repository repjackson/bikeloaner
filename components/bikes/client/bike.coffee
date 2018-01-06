FlowRouter.route '/bike/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'bike'



Template.bike.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.bike.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
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
    
    
Template.bike.onCreated ->
    @autorun -> Meteor.subscribe 'bike', FlowRouter.getParam('doc_id')

Template.bike.helpers
    bike: ->
        Docs.findOne FlowRouter.getParam('doc_id')
    
        
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
