FlowRouter.route '/volunteer', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'volunteer'



Template.volunteer.onCreated -> 
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'shift')

Template.volunteer.helpers
    shifts: -> 
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

    
                    
FlowRouter.route '/shift/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'shift'



Template.shift.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')


Template.shift.helpers
    shift: -> Docs.findOne FlowRouter.getParam('doc_id')
    