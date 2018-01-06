Docs.before.insert (userId, doc)->
    doc.openings = 0
    doc.volunteers = []
    doc.date = '' 
    return


FlowRouter.route '/volunteer', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'volunteer'



if Meteor.isClient
    Template.volunteer.onCreated -> 
        @autorun -> 
            Meteor.subscribe('shifts')
            Meteor.subscribe('shift_volunteers')

    Template.volunteer.helpers
        volunteer_shifts: -> 
            Docs.find { type:'shift' }, 
                sort:
                    date: 1
                    
        formatted_date: -> moment(@date).format("dddd, MMMM Do")
                   
        volunteer: -> Meteor.users.findOne @valueOf()
                   
        signed_up_for_first: -> Meteor.userId() in @volunteers
    
    
    Template.volunteer.events
        'click #add_shift': -> 
            id = Docs.insert 
                type:'shift'
                openings: 4
                volunteer_id: []
            FlowRouter.go "/shift/#{id}"

        'click #join_shift': -> 
            Docs.update @_id,
                $addToSet: 
                    volunteer_ids: Meteor.userId()
            
        'click #leave_shift': -> 
            Docs.update @_id,
                $pull: 
                    volunteer_ids: Meteor.userId()

    
                    
FlowRouter.route '/shift/:shift_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'shift'



Template.shift.onCreated ->
    @autorun -> Meteor.subscribe 'shift', FlowRouter.getParam('shift_id')


Template.shift.helpers
    shift: -> Docs.findOne FlowRouter.getParam('shift_id')
    