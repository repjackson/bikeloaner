FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        selected_theme_tags.clear()
        BlazeLayout.render 'layout',
            main: 'view_doc'

Template.view_doc.onRendered ->
    selected_theme_tags.clear()
    
Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'doc', Session.get('editing_id')
    # @autorun -> Meteor.subscribe 'my_children', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'usernames'
    @autorun -> Meteor.subscribe 'components'
    @autorun => Meteor.subscribe 'completors', FlowRouter.getParam('doc_id')

    @autorun => 
        Meteor.subscribe('facet', 
            selected_theme_tags.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_intention_tags.array()
            selected_timestamp_tags.array()
            type = null
            author_id = null
            parent_id = FlowRouter.getParam('doc_id')
            tag_limit = 20
            doc_limit = 20
            view_published = 
                if Session.equals('admin_mode', true) then true else Session.get('view_published')
            view_read = null
            view_bookmarked = null
            view_resonates = null
            view_complete = null
            view_images = null
            view_lightbank_type = null

            )

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    children: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')

        if doc.sort_by 
            if doc.sort_by is 'number'
                sort_object = number: 1
            else if doc.sort_by is 'timestamp'
                sort_object = timestamp: -1
        else 
            sort_object = {number: 1, timestamp: -1}
            
        doc_limit = if doc.result_limit then parseInt(doc.result_limit) else 20
            
        # console.log sort_object    
            
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        
        else if Roles.userIsInRole(Meteor.userId(), 'admin')
            Docs.find {
                type: $ne: 'session'
                parent_id: FlowRouter.getParam 'doc_id'
            }, {
                sort: sort_object
                limit: doc_limit
            }
        else
            Docs.find {
                type: $ne: 'session'
                parent_id: FlowRouter.getParam 'doc_id'
                published: 1
            }, {
                sort: sort_object
                limit: doc_limit
            }

    components: ->        
        Docs.find
            # type: 'component'
            parent_id: 'MzHSPbvCYPngq2Dcz'
            

    slug_exists: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        # if doc["#{@slug}"]? then console.log "#{@slug} exists" else console.log "#{@slug} no" 
        if doc["#{@slug}"]? then true else false
        
        
    main_column_class: -> 
        if Session.equals 'editing', true 
            'ten wide column' 
        else
            'sixteen wide column'

    field_segment_class: -> if Session.equals 'editing', true then '' else 'basic compact'
    
    
    completors: ->
        if @completed_by
            if @completed_by.length > 0
        # console.log @completed_by
                Meteor.users.find _id: $in: @completed_by
        else 
            false
        
    
    response_completion: -> @completion_type is 'response'
    read_completion: -> @completion_type is 'mark_read'
    session_completion: -> @completion_type is 'session'
    
    read: -> @read_by and Meteor.userId() in @read_by
    
    response_doc: -> 
        response_doc = Docs.findOne
            parent_id: FlowRouter.getParam('doc_id')
            author_id: Meteor.userId()
        if response_doc then return true else false
    
    doc_child_view: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        doc.child_view
        # if doc.can_change_view_mode
        #     switch Session.get('view_mode')
        #         when 'list' then 'list_item'
        #         when 'cards' then 'card_view'
        #         when 'flash_cards' then 'flash_card'
        #         when 'qa_session' then 'q_a'
        # else
        # console.log doc.child_view
        # console.log typeof doc.child_view
        # if doc.child_view is 'grid_item'
        #     console.log 'choosing nav'
        #     return 'grid_item'
        # else if doc.child_view is 'cards'
        #     console.log 'card_view'
        #     return 'card_view'
    
    q_a_view: -> @child_view is 'q_a'
    grandchild_list_view: -> @child_view is 'grandchild_list'
    quiz_view: -> @child_view is 'quiz'
    
    is_editing_session_id: -> Session.get 'editing_session_id'

    

Template.view_doc.events
    'click #create_parent': ->
        new_parent_id = Docs.insert {}
        Docs.update FlowRouter.getParam('doc_id'),
            $set: parent_id: new_parent_id
        FlowRouter.go "/view/#{new_parent_id}" 
        
      
    'click #logout': -> AccountsTemplates.logout()
      
      
    'click #admin_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        # FlowRouter.go("/view/#{new_id}")
        # Session.set 'editing', true
      
    'click #user_add': ->
        new_id = Docs.insert
            parent_id: FlowRouter.getParam('doc_id')
        Session.set 'editing_id', new_id
      
      