FlowRouter.route '/faq', action: ->
    BlazeLayout.render 'layout', 
        main: 'faq'

Template.faq.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'question')


Template.faq.helpers
    questions: -> Docs.find {type: 'question'}
     
     
Template.faq.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
     
            
Template.faq.events
    'click #add_question': ->
        id = Docs.insert
            type: 'question'
        Session.set 'editing_id', id
        
        

Template.question_item.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.question_item.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.question_item.events
    'click #delete': ->
        swal {
            title: 'Delete Question?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, ->
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove doc._id, ->
                FlowRouter.go "/faq"        
                
                
                
FlowRouter.route '/question/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'question'

Template.question.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.question.helpers
    question: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.question.events
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
                FlowRouter.go "/faq"        