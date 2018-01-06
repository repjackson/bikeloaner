FlowRouter.route '/bikes', action: ->
    BlazeLayout.render 'layout', 
        main: 'bikes'

Template.bikes.onCreated ->
    @autorun -> Meteor.subscribe('facet', selected_tags.array(), 'bike')


Template.bikes.helpers
    bikes: -> Docs.find {type: 'bike'}
            
Template.bikes.events
    'click #add_bike': ->
        id = Docs.insert
            type: 'bike'
        FlowRouter.go "/bike/#{id}"
        Session.set 'editing', true