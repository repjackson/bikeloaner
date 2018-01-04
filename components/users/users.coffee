FlowRouter.route '/users', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'users'



if Meteor.isClient
    Template.users.onCreated ->
        @autorun -> Meteor.subscribe('people', selected_user_tags.array())
    Template.user.onCreated ->
        @autorun -> Meteor.subscribe('person', @_id)
    
    
    Template.users.helpers
        people: -> 
            # Meteor.users.find { _id: $ne: Meteor.userId() }, 
            Meteor.users.find { }, 
                sort:
                    tag_count: 1
                limit: 10
    
        tag_class: -> if @valueOf() in selected_user_tags.array() then 'primary' else ''

    Template.user.events
        'click .user_tag': ->
            if @valueOf() in selected_user_tags.array() then selected_user_tags.remove @valueOf() else selected_user_tags.push @valueOf()

    Template.user.helpers
        five_tags: -> if @tags then @tags[..4]
    
