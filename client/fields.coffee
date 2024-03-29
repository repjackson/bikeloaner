Template.author_name.events
    'blur #author_name': (e,t)->
        author_name = $(e.currentTarget).closest('#author_name').val()
        Docs.update @_id,
            $set: author_name: author_name
            
Template.icon_class.events
    'blur #icon_class': (e,t)->
        val = $(e.currentTarget).closest('#icon_class').val()

        Docs.update @_id,
            $set: icon_class: val
            
Template.created_date.helpers
    created_date: -> 
        console.log @timestamp
        @timestamp

Template.created_date.events
    'blur #created_date': ->
        created_date = $('#created_date').val()
        console.log created_date
        # Docs.update @_id,
        #     $set: created_date: created_date
            

Template.tags.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update Template.currentData()._id,
            $addToSet: tags: doc.name
        $('#theme_tag_select').val('')
   
    'keyup #theme_tag_select': (e,t)->
        e.preventDefault()
        val = $('#theme_tag_select').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update Template.currentData()._id,
                        $addToSet: tags: val
                    $('#theme_tag_select').val ''
            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(Template.currentData()._id).tags.slice -1
            #         $('#theme_tag_select').val result[0]
            #         Docs.update Template.currentData()._id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#theme_tag_select').val(tag)
        
Template.tags.helpers
    # editing_mode: -> 
    #     console.log Session.get 'editing'
    #     if Session.equals 'editing', true then true else false
    theme_select_settings: -> {
        position: 'top'
        limit: 10
        rules: [
            {
                collection: Tags
                field: 'name'
                matchAll: false
                template: Template.tag_result
            }
            ]
    }




            
Template.title.events
    'blur #title': (e,t)->
        title = $(e.currentTarget).closest('#title').val()
        Docs.update @_id,
            $set: title: title
            
            
Template.image_id.events
    "change input[type='file']": (e) ->
        doc_id = @_id
        files = e.currentTarget.files


        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                # console.log "Upload Error: #{err}"
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    Docs.update doc_id, $set: image_id: res.public_id
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = @_id
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Docs.update doc_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')



    'click #remove_photo': ->
        swal {
            title: 'Remove Photo?'
            type: 'warning'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Meteor.call "c.delete_by_public_id", @image_id, (err,res) =>
                if not err
                    # Do Stuff with res
                    # console.log res
                    # console.log @image_id, @_id
                    Docs.update @_id, 
                        $unset: 
                            image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"

Template.image_url.events
    'click #remove_image_url': ->
        Docs.update @_id, 
            $unset: 
                image_url: 1
        
    'blur #image_url': ->
        image_url = $('#image_url').val()
        Docs.update @_id,
            $set: image_url: image_url


            
Template.content.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # snippet = $('#snippet').val()
        # if snippet.length is 0
        #     snippet = $(html).text().substr(0, 300).concat('...')
        doc_id = @_id

        Docs.update doc_id,
            $set: content: html
                

Template.content.helpers
    getFEContext: ->
        @current_doc = Docs.findOne @_id
        self = @
        {
            _value: self.current_doc.content
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                #   'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            toolbarButtonsMD: ['bold', 'italic', 'underline']
            toolbarButtonsSM: ['bold', 'italic', 'underline']
            toolbarButtonsXS: ['bold', 'italic', 'underline']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }



Template.youtube.events
    'blur #youtube': (e,t)->
        youtube = $(e.currentTarget).closest('#youtube').val()
        Docs.update @_id,
            $set: youtube: youtube
            
    'click #clear_youtube': (e,t)->
        $(e.currentTarget).closest('#youtube').val('')
        Docs.update @_id,
            $unset: youtube: 1
            
Template.youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000


Template.participants.onCreated ->
    Meteor.subscribe 'usernames'

Template.participants.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        Docs.update FlowRouter.getParam('doc_id'),
            $addToSet: participant_ids: doc._id
        $('#participant_select').val("")
   
    'click #remove_participant': (e,t)->
        # console.log @
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: participant_ids: @_id



Template.participants.helpers
    participants_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    participants: ->
        participants = []
        
        for participant_id in @participant_ids
            participants.push Meteor.users.findOne(participant_id)
        participants


Template.edit_author.onCreated ->
    Meteor.subscribe 'usernames'

Template.edit_author.events
    "autocompleteselect input": (event, template, doc) ->
        # console.log("selected ", doc)
        if confirm 'Change author?'
            Docs.update FlowRouter.getParam('doc_id'),
                $set: author_id: doc._id
            $('#author_select').val("")



Template.edit_author.helpers
    author_edit_settings: -> {
        position: 'bottom'
        limit: 10
        rules: [
            {
                collection: Meteor.users
                field: 'username'
                matchAll: true
                template: Template.user_pill
            }
            ]
    }

    # edit_author: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants


Template.start_date.events
    'blur #start_date': ->
        start_date = $('#start_date').val()
        Docs.update @_id,
            $set: start_date: start_date
    
Template.date.events
    'blur #date': ->
        date = $('#date').val()
        Docs.update @_id,
            $set: date: date
    
Template.publish_date.events
    'blur #publish_date': ->
        publish_date = $('#publish_date').val()
        Docs.update @_id,
            $set: publish_date: publish_date
    
Template.start_datetime.events
    'blur #start_datetime': ->
        start_datetime = $('#start_datetime').val()
        Docs.update @_id,
            $set: start_datetime: start_datetime


Template.end_datetime.events
    'blur #end_datetime': ->
        end_datetime = $('#end_datetime').val()
        Docs.update @_id,
            $set: end_datetime: end_datetime

Template.time_marker.events
    'blur #time_marker': ->
        time_marker = parseFloat $('#time_marker').val()
        Docs.update @_id,
            $set: time_marker: time_marker
            
            

Template.edit_image_field.events
    "change input[type='file']": (e) ->
        doc_id = FlowRouter.getParam('doc_id')
        files = e.currentTarget.files


        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                # console.log "Upload Error: #{err}"
                # console.dir res
                if err
                    console.error 'Error uploading', err
                    Bert.alert "Error uploading #{@label}: #{err}", 'danger', 'growl-top-right'
                else
                    Docs.update doc_id, 
                        { $set: image_id: res.public_id }
                        , (err,res)=>
                            if err
                                Bert.alert "Error Updating Image: #{error.reason}", 'danger', 'growl-top-right'
                            else
                                Bert.alert "Updated Image", 'success', 'growl-top-right'
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Docs.update doc_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')



    'click #remove_photo': ->
        swal {
            title: 'Remove Photo?'
            type: 'warning'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Meteor.call "c.delete_by_public_id", @image_id, (err,res) ->
                if not err
                    # Do Stuff with res
                    # console.log res
                    Docs.update FlowRouter.getParam('doc_id'), 
                        $unset: image_id: 1

                else
                    throw new Meteor.Error "it failed"

    #         console.log Cloudinary
    # 		Cloudinary.delete "37hr", (err,res) ->
    # 		    if err 
    # 		        console.log "Upload Error: #{err}"
    # 		    else
    #     			console.log "Upload Result: #{res}"
    #                 # Docs.update FlowRouter.getParam('doc_id'), 
    #                 #     $unset: image_id: 1

    # Template.edit_image.helpers
    #     log: -> console.log @



Template.edit_number_field.events
    'change #number_field': (e,t)->
        number_value = parseInt e.currentTarget.value
        Docs.update FlowRouter.getParam('doc_id'),
            { $set: "#{@key}": number_value }
            , (err,res)=>
                if err
                    Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
                else
                    Bert.alert "Updated #{@label}", 'success', 'growl-top-right'
            
Template.edit_textarea.events
    'blur #textarea': (e,t)->
        doc_id = FlowRouter.getParam('doc_id')
        textarea_value = $('#textarea').val()
        Docs.update doc_id,
            { $set: "#{@key}": textarea_value }
            , (err,res)=>
                if err
                    Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
                else
                    Bert.alert "Updated #{@label}", 'success', 'growl-top-right'


Template.edit_date_field.events
    'change #date_field': (e,t)->
        date_value = e.currentTarget.value
        Docs.update FlowRouter.getParam('doc_id'),
            { $set: "#{@key}": date_value } 
            , (err,res)=>
                if err
                    Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
                else
                    Bert.alert "Updated #{@label}", 'success', 'growl-top-right'


Template.edit_text_field.events
    'change #text_field': (e,t)->
        text_value = e.currentTarget.value
        Docs.update FlowRouter.getParam('doc_id'),
            { $set: "#{@key}": text_value }
            , (err,res)=>
                if err
                    Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
                else
                    Bert.alert "Updated #{@label}", 'success', 'growl-top-right'




Template.complete.events
    'click #mark_complete': (e,t)->
        Docs.update @_id,
            $set: complete: true
    'click #mark_incomplete': (e,t)->
        Docs.update @_id,
            $set: complete: false

Template.complete.helpers
    complete_class: -> if @complete then 'green' else 'basic'
    incomplete_class: -> if @complete then 'basic' else 'red'


Template.toggle_follow.helpers
    is_following: -> if Meteor.user()?.following_ids then @_id in Meteor.user().following_ids
        
Template.toggle_follow.events
    'click #follow': (e,t)-> 
        Meteor.users.update Meteor.userId(), $addToSet: following_ids: @_id

        # Meteor.call 'add_notification', @_id, 'friended', Meteor.userId()

    'click #unfollow': (e,t)-> 
        Meteor.users.update Meteor.userId(), $pull: following_ids: @_id

        # Meteor.call 'add_notification', @_id, 'unfriended', Meteor.userId()

Template.vote_button.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.vote_button.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'
            
        
        
Template.toggle_key.helpers
    toggle_key_button_class: -> 
        current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        # console.log current_doc["#{@key}"]
        # console.log @key
        # console.log Template.parentData()
        # console.log Template.parentData()["#{@key}"]
        
        if @value
            if current_doc["#{@key}"] is @value then 'active' else 'basic'
        else if current_doc["#{@key}"] is true then 'active' else 'basic'


Template.toggle_key.events
    'click #toggle_key': ->
        # console.log @
        if @value
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": "#{@value}"
        else if Template.parentData()["#{@key}"] is true
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": false
        else
            Docs.update FlowRouter.getParam('doc_id'), 
                $set: "#{@key}": true



Template.edit_html_field.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        doc_id = FlowRouter.getParam('doc_id')

        Docs.update doc_id,
            $set: 
                description: html




Template.edit_html_field.helpers
    getFEContext: ->
        @current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        self = @
        {
            _value: self.current_doc.description
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            # imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
            '_onsave.before': (e, editor) ->
                # Get edited HTML from Froala-Editor
                newHTML = editor.html.get(true)
                # Do something to update the edited value provided by the Froala-Editor plugin, if it has changed:
                if !_.isEqual(newHTML, self.current_doc.description)
                    # console.log 'onSave HTML is :' + newHTML
                    Docs.update { _id: self.current_doc._id }, $set: description: newHTML
                false
                # Stop Froala Editor from POSTing to the Save URL
        }


Template.toggle_boolean.events
    'click #make_featured': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: featured: true

    'click #make_unfeatured': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: featured: false
            