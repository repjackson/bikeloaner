FlowRouter.route '/people', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'people'



Template.people.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_user_tags.array())

Template.person.onCreated ->
    @autorun -> Meteor.subscribe('person', @_id)

Template.people.helpers
    people: -> 
        # Meteor.people.find { _id: $ne: Meteor.userId() }, 
        Meteor.users.find { }

    tag_class: -> if @valueOf() in selected_user_tags.array() then 'primary' else ''

Template.person.events
    'click .user_tag': ->
        if @valueOf() in selected_user_tags.array() then selected_user_tags.remove @valueOf() else selected_user_tags.push @valueOf()

Template.person.helpers
    five_tags: -> if @tags then @tags[..4]

