
$.cloudinary.config
    cloud_name:"facet"

    
FlowRouter.route '/', action: ->
    BlazeLayout.render 'layout',
        main: 'home'

FlowRouter.route '/contact', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'contact'

FlowRouter.route '/about', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'about'

    
FlowRouter.route '/faq', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'faq'

    
FlowRouter.route '/donate', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'donate'

    
    
Session.setDefault 'editing', false
    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is FlowRouter.getParam('username')

Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'admin_mode', () ->  Session.get 'admin_mode'
Template.registerHelper 'editing', () ->  Session.get('editing')
Template.registerHelper 'theme_tag_class': -> if @valueOf() in selected_tags.array() then 'teal' else 'basic'
Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_start_date', () -> moment(@start_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_end_date', () -> moment(@end_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'tag_class', ()-> if @valueOf() in selected_tags.array() then 'blue' else 'basic'
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev', () -> Meteor.isDevelopment




FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'