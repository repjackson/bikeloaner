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