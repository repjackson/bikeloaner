FlowRouter.route '/bike/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'bike'



Template.bike.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')

Template.bike.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    
    
Template.bike.events
    'click #delete': ->
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
        }, ->
            bike = Docs.findOne FlowRouter.getParam('bikes_id')
            Docs.remove bike._id, ->
                FlowRouter.go "/bikes"
    
    
Template.bike.onCreated ->
    @autorun -> Meteor.subscribe 'bike', FlowRouter.getParam('doc_id')

Template.bike.helpers
    bike: ->
        Docs.findOne FlowRouter.getParam('doc_id')
    
        
Template.bike.events
    'click #save_bike': ->
        title = $('#title').val()
        publish_date = $('#publish_date').val()
        body = $('#body').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set:
                title: title
                publish_date: publish_date
                body: body
        FlowRouter.go "/bike/view/#{@_id}"
        
    'blur #title': ->
        title = $('#title').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: title: title
    
    
    'keydown #add_tag': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            tag = $('#add_tag').val().toLowerCase().trim()
            if tag.length > 0
                Docs.update doc_id,
                    $addToSet: tags: tag
                $('#add_tag').val('')

    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: tags: tag
        $('#add_tag').val(tag)
        
        
    'click #delete': ->
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
        }, ->
            bike = Docs.findOne FlowRouter.getParam('bikes_id')
            Docs.remove bike._id, ->
                FlowRouter.go "/bikes"
