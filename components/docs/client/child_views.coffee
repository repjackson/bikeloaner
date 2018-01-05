Template.card_view.helpers
    child_view_fields: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.child_fields
    
    doc: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
    parent_doc: ->
        Template.parentData()
    
    has_title: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'title' in doc.child_fields
    show_header: -> @title or @number or @icon_class or @end_date
    
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'content' in doc.child_fields
        
    has_content: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        'tags' in doc.child_fields
        
    favoriter_list: ->
        if @favoriters
            if @favoriters.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @favoriters
        else 
            false
        
    upvoter_list: ->
        if @upvoters
            if @upvoters.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @upvoters
        else 
            false
        