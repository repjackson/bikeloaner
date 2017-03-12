@Days = new Meteor.Collection 'days'

Days.before.insert (userId, doc)->
    doc.openings = 0
    doc.slot_1_volunteers = []
    doc.slot_2_volunteers = []
    doc.date = '' 
    return


Days.after.update ((userId, doc, fieldNames, modifier, options) ->
    doc.tag_count = doc.tags?.length
    # Meteor.call 'generate_authored_cloud'
), fetchPrevious: true


Days.helpers
    when: -> moment(@timestamp).fromNow()

FlowRouter.route '/scheduling', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'scheduling'



if Meteor.isClient
    Template.scheduling.onCreated -> 
        @autorun -> Meteor.subscribe('days')

    Template.scheduling.helpers
        volunteer_days: -> 
            Days.find { }, 
                sort:
                    date: 1
                    
        formatted_date: ->
            moment(@date).format("dddd, MMMM Do")
                    
    
    Template.scheduling.events
        'click #add_day': -> 
            id = Days.insert {}
            FlowRouter.go "/day/edit/#{id}"



if Meteor.isServer
    Days.allow
        insert: (userId, doc) -> userId
        update: (userId, doc) -> userId or Roles.userIsInRole(userId, 'admin')
        remove: (userId, doc) -> userId or Roles.userIsInRole(userId, 'admin')
    
    Meteor.publish 'day', (day_id)->
        Days.find day_id
        
    Meteor.publish 'days', ()->
        Days.find()
        
        
        
        