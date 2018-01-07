FlowRouter.route '/posts', action: ->
    BlazeLayout.render 'layout', 
        main: 'posts'

Template.posts.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'post')


Template.posts.helpers
    posts: -> 
        Docs.find {type: 'post'},
            sort:
                publish_date: -1
            limit: 10
            
Template.posts.events
    'click #add_post': ->
        id = Docs.insert
            type: 'post'
        FlowRouter.go "/post/#{id}"
        Session.set 'editing', true
        
        
        
FlowRouter.route '/post/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'post'



Template.post.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.post.helpers
    post: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.post.events
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
            post = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.remove post._id, ->
                FlowRouter.go "/posts"
            