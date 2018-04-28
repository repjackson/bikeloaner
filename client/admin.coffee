FlowRouter.route '/admin', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'admin'



Template.admin.onCreated ->
    @autorun -> Meteor.subscribe('admin', selected_user_tags.array())

Template.person.onCreated ->
    @autorun -> Meteor.subscribe('person', @_id)

Template.admin.helpers
    admin: -> 
        # Meteor.admin.find { _id: $ne: Meteor.userId() }, 
        Meteor.users.find { }

    tag_class: -> if @valueOf() in selected_user_tags.array() then 'primary' else ''
