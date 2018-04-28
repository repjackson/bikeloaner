Template.read_by_list.onCreated ->
    @autorun => Meteor.subscribe 'read_by', Template.parentData()._id
    
Template.read_by_list.helpers
    read_by: ->
        if @read_by
            if @read_by.length > 0
        # console.log @read_by
                Meteor.users.find _id: $in: @read_by
        else 
            false
            
            
            
Template.mark_read.events
    'click .mark_read': (e,t)-> 
        Meteor.call 'mark_read', @_id
        
    'click .mark_unread': (e,t)-> Meteor.call 'mark_unread', @_id

Template.mark_read.helpers
    read: -> @read_by and Meteor.userId() in @read_by
    # read: -> true
    


    
Template.named_content.onCreated ->
    @autorun => Meteor.subscribe 'named_doc', @data.name
    
Template.named_content.events
    'click #create_doc': ->
        Docs.insert
            name: @name
            
Template.named_content.helpers
    named_doc: ->
        Docs.findOne 
            name: Template.currentData().name
            
            
Template.add_button.events
    'click #add': -> 
        id = Docs.insert type:@type
        FlowRouter.go "/edit/#{id}"
            