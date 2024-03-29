FlowRouter.route '/profile/:user_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'view_profile'


FlowRouter.route '/profile/:user_id/edit', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_profile'





Template.edit_profile.onCreated ->
    @autorun -> Meteor.subscribe 'user_profile', FlowRouter.getParam('user_id') 

# Template.edit_profile.onRendered ->
#     console.log Meteor.users.findOne(FlowRouter.getParam('user_id'))

Template.edit_profile.helpers
    user: -> Meteor.users.findOne FlowRouter.getParam('user_id')

Template.edit_profile.events
    'blur #first_name': ->
        first_name = $('#first_name').val().trim()
        Meteor.users.update FlowRouter.getParam('user_id'),
            $set: 
                "profile.first_name": first_name

        
    'blur #last_name': ->
        last_name = $('#last_name').val().trim()
        Meteor.users.update FlowRouter.getParam('user_id'),
            $set: 
                "profile.last_name": last_name

        
    'blur #phone': ->
        phone = $('#phone').val().trim()
        Meteor.users.update FlowRouter.getParam('user_id'),
            $set: 
                "profile.phone": phone

        
    'blur #bio': ->
        bio = $('#bio').val().trim()
        Meteor.users.update FlowRouter.getParam('user_id'),
            $set: 
                "profile.bio": bio

        
    'keydown #input_image_id': (e,t)->
        if e.which is 13
            user_id = FlowRouter.getParam('user_id')
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Meteor.users.update user_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')
            
            
    'keydown #add_tag': (e,t)->
        if e.which is 13
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Meteor.users.update FlowRouter.getParam('user_id'),
                    $addToSet: tags: tag
                $('#add_tag').val('')

    'click .person_tag': (e,t)->
        tag = @valueOf()
        Meteor.users.update FlowRouter.getParam('user_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)

    'click #save_profile': ->
        FlowRouter.go "/profile/view/#{@_id}"

    "change input[type='file']": (e) ->
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
                    Meteor.users.update FlowRouter.getParam('user_id'),
                        $set: "profile.image_id": res.public_id
                return

    'click #remove_photo': ->
        Meteor.users.update FlowRouter.getParam('user_id'),
            $unset: image_id: 1
            
            
            
    'change #newsletter': (e,t)->
        # console.log e.currentTarget.value
        value = $('#newsletter').is(":checked")
        Meteor.users.update FlowRouter.getParam('user_id'), 
            $set:
                "profile.subscribe": value
                    
                    
Template.view_profile.onCreated ->
    @autorun -> Meteor.subscribe('user_profile', FlowRouter.getParam('user_id'))
    

Template.view_profile.helpers
    person: -> 
        Meteor.users.findOne FlowRouter.getParam('user_id') 
    


Template.view_profile.events
                    