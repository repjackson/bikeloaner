FlowRouter.route '/day/edit/:day_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_day'



if Meteor.isClient
    Template.edit_day.onCreated ->
        @autorun -> Meteor.subscribe 'day', FlowRouter.getParam('day_id')
    
    
    Template.edit_day.helpers
        day: -> Days.findOne FlowRouter.getParam('day_id')
        
    
            
            
    Template.edit_day.events
        'blur #date': ->
            date = $('#date').val()
            
            Days.update FlowRouter.getParam('day_id'),
                $set: date: date
            
            
        'click #save_day': ->
            FlowRouter.go "/scheduling"
    