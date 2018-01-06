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
    


Template.save_button.events
    'click #toggle_off_editing': -> Session.set 'editing', false
    
    
Template.named_content.onCreated ->
    console.log @name
    @autorun => Meteor.subscribe 'named_doc', @name