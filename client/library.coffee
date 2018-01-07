FlowRouter.route '/library', action: ->
    BlazeLayout.render 'layout', 
        main: 'library'

Template.library.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'doc')


Template.library.helpers
    docs: -> Docs.find {type: 'doc'}
            
Template.library.events
    'click #add_doc': ->
        id = Docs.insert
            type: 'doc'
        FlowRouter.go "/doc/#{id}"
        Session.set 'editing', true
        
        
FlowRouter.route '/doc/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'doc'



Template.doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.doc.events
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
            doc = Docs.findOne FlowRouter.getParam('library_id')
            Docs.remove doc._id, ->
                FlowRouter.go "/library"        