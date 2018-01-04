if Meteor.isClient
    Template.nav.events
        'click #logout': -> 
            AccountsTemplates.logout()
            
        'click #toggle_admin_mode': ->
            if Session.equals('admin_mode', true) then Session.set('admin_mode', false)
            else if Session.equals('admin_mode', false) then Session.set('admin_mode', true)
            Session.set 'editing_id', null
            Session.set 'view_published', null
        

        
    Template.nav.onCreated ->
        @autorun -> 
            Meteor.subscribe 'me'
        
    Template.nav.helpers
        notifications: -> 
            Notifications.find()



if Meteor.isServer
    Meteor.publish 'me', ->
        Meteor.users.find @userId,
            fields: 
                courses: 1
