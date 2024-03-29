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
            
            
Template.toggle_boolean.events
    'click #make_featured': ->
        Docs.update FlowRouter.getParam('doc_id'), $set: featured: true

    'click #make_unfeatured': ->
        Docs.update FlowRouter.getParam('doc_id'), $set: featured: false

Template.add_button.events
    'click #add': -> 
        id = Docs.insert type:@type
        FlowRouter.go "/edit/#{id}"


Template.reference_office.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], @data.type
Template.reference_customer.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], @data.type

Template.associated_users.onCreated ->
    @autorun =>  Meteor.subscribe 'docs', [], 'person'
Template.associated_users.helpers
    users: -> Docs.find type:'person'


Template.reference_office.helpers
    settings: -> 
        # console.log @
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Docs
                    field: "#{@search_field}"
                    matchAll: true
                    filter: { type: "#{@type}" }
                    template: Template.office_result
                }
            ]
        }

Template.reference_customer.helpers
    settings: -> 
        # console.log @
        {
            position: 'bottom'
            limit: 10
            rules: [
                {
                    collection: Docs
                    field: "#{@search_field}"
                    matchAll: true
                    filter: { type: "#{@type}" }
                    template: Template.customer_result
                }
            ]
        }


Template.reference_office.events
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        searched_value = doc["#{template.data.key}"]
        # console.log 'template ', template
        # console.log 'search value ', searched_value
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{template.data.key}": "#{doc._id}"
        $('#search').val ''

Template.reference_customer.events
    'autocompleteselect #search': (event, template, doc) ->
        # console.log 'selected ', doc
        searched_value = doc["#{template.data.key}"]
        # console.log 'template ', template
        # console.log 'search value ', searched_value
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{template.data.key}": "#{doc._id}"
        $('#search').val ''




Template.set_view_mode.helpers
    view_mode_button_class: -> if Session.equals('view_mode', @view) then 'active' else 'basic'

Template.set_view_mode.events
    'click #set_view_mode': -> Session.set 'view_mode', @view
            
Template.set_session_button.events
    'click .set_session_filter': -> Session.set "#{@key}", @value
            
Template.set_session_button.helpers
    filter_class: -> 
        if Session.equals("#{@key}","all") 
            if @value is 'all'
                'active' 
            else
                'basic'
        else if Session.get("#{@key}")
            if Session.equals("#{@key}", parseInt(@value))
                'active'
            else
                'basic'
            
            
            
Template.set_session_item.events
    'click .set_session_filter': -> Session.set "#{@key}", @value
            

Template.delete_button.events
    'click #delete': ->
        template = Template.currentData()
        swal {
            title: 'Delete?'
            # text: 'Confirm delete?'
            type: 'error'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'Cancel'
            confirmButtonText: 'Delete'
            confirmButtonColor: '#da5347'
        }, =>
            # doc = Docs.findOne FlowRouter.getParam('doc_id')
            # Docs.remove doc._id, ->
            #     FlowRouter.go "/docs"
            console.log template



Template.edit_link.events
    'blur #link': ->
        link = $('#link').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: link: link
            
            
Template.publish_button.events
    'click #publish': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: published: true

    'click #unpublish': ->
        Docs.update FlowRouter.getParam('doc_id'),
            $set: published: false
            
            
Template.call_method.events
    'click .call_method': -> 
        # console.log Template.parentData(1)
        Meteor.call @name, Template.parentData(1)._id, (err,res)->
            # if err then console.log err
            # else
                # console.log 'res', res
                
                
Template.html_create.onCreated ->
    @autorun => Meteor.subscribe 'facet_doc', @data.tags
    
Template.html_create.helpers
    doc: ->
        tags = Template.currentData().tags
        split_array = tags.split ','

        Docs.findOne
            tags: split_array

    template_tags: -> Template.currentData().tags

    doc_classes: -> Template.parentData().classes

Template.html_create.events
    'click .create_doc': (e,t)->
        tags = t.data.tags
        split_array = tags.split ','
        new_id = Docs.insert
            tags: split_array
        Session.set 'editing_id', new_id

    'blur #staff': ->
        staff = $('#staff').val()
        Docs.update @_id,
            $set: staff: staff                
            
            
Template.google_places_input.onRendered ->
    # input = document.getElementById('google_places_field');
    # options = {
    #     types: ['geocode'],
    #     # componentRestrictions: {country: 'fr'}
    # }
    # @autocomplete = new google.maps.places.Autocomplete(input, options);
    # # console.log @autocomplete.getPlace
    @autorun(() =>
        if GoogleMaps.loaded()
            # $('#google_places_field').geocomplete();
            $("#google_places_field").geocomplete().bind("geocode:result", (event, result)->
                console.log(result)
                lat = result.geometry.location.lat()
                long = result.geometry.location.lng()
                result.lat = lat
                result.lng = long
                if confirm "change location to #{result.formatted_address}?"
                    Meteor.call 'update_location', FlowRouter.getParam('doc_id'), result
                )
    )


# Template.google_places_input.events
    # 'change #google_places_field': (e,t)->
    #     console.log $('#google_places_field').geocomplete();

        # result = t.autocomplete.gm_accessors_.place.jd.w3
        # console.dir result
        # Meteor.call 'update_location', FlowRouter.getParam('doc_id'), result, (err,res)->
            # console./log res
        # stuff = Template.instance().autocomplete.gm_accessors_.place
        # Docs.update FlowRouter.getParam('doc_id'),
        #     $set: stuff: stuff
        # console.dir stuff.jd.formattedPrediction
        
Template.office_map.onRendered ->
    doc = Docs.findOne FlowRouter.getParam('doc_id')
    # console.log doc.location_ob.geometry
    mymap = L.map('map').setView([doc.location_lat, doc.location_lng], 15);
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
        # attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
        maxZoom: 18,
        id: 'mapbox.streets',
        accessToken: 'pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJjamc4dGtiYm4yN245MnFuNWMydWNuaXJlIn0.z3_-xuCT46yTC_6Zhl34kQ'
    }).addTo(mymap);
