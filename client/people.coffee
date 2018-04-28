FlowRouter.route '/people', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'people'



Template.people.onCreated ->
    @autorun -> Meteor.subscribe('people', selected_user_tags.array())

Template.person.onCreated ->
    @autorun -> Meteor.subscribe('person', @_id)

Template.people.helpers
    people: -> 
        # Meteor.people.find { _id: $ne: Meteor.userId() }, 
        Meteor.users.find { }

    tag_class: -> if @valueOf() in selected_user_tags.array() then 'primary' else ''

Template.person.events
    'click .user_tag': ->
        if @valueOf() in selected_user_tags.array() then selected_user_tags.remove @valueOf() else selected_user_tags.push @valueOf()

Template.person.helpers
    five_tags: -> if @tags then @tags[..4]

Template.people.events
    'click .remove_admin': ->
        self = @
        swal {
            title: "Remove #{@emails[0].address} from Admins?"
            # text: 'You will not be able to recover this imaginary file!'
            type: 'warning'
            animation: false
            showCancelButton: true
            # confirmButtonColor: '#DD6B55'
            confirmButtonText: 'Remove Privilages'
            closeOnConfirm: false
        }, ->
            Roles.removeUsersFromRoles self._id, 'admin'
            swal "Removed Admin Privilages from #{self.emails[0].address}", "",'success'
            return


    'click .make_admin': ->
        self = @
        swal {
            title: "Make #{@emails[0].address} an Admin?"
            # text: 'You will not be able to recover this imaginary file!'
            type: 'warning'
            animation: false
            showCancelButton: true
            # confirmButtonColor: '#DD6B55'
            confirmButtonText: 'Make Admin'
            closeOnConfirm: false
        }, ->
            Roles.addUsersToRoles self._id, 'admin'
            swal "Made #{self.emails[0].address} an Admin", "",'success'
            return

    'click .remove_member': ->
        self = @
        swal {
            title: "Remove #{@emails[0].address} from members?"
            # text: 'You will not be able to recover this imaginary file!'
            type: 'warning'
            animation: false
            showCancelButton: true
            # confirmButtonColor: '#DD6B55'
            confirmButtonText: 'Remove Member Status'
            closeOnConfirm: false
        }, ->
            Roles.removeUsersFromRoles self._id, 'member'
            swal "Removed member privilages from #{self.emails[0].address}", "",'success'
            return


    'click .make_member': ->
        self = @
        swal {
            title: "Make #{@emails[0].address} a member?"
            # text: 'You will not be able to recover this imaginary file!'
            type: 'warning'
            animation: false
            showCancelButton: true
            # confirmButtonColor: '#DD6B55'
            confirmButtonText: 'Make Member'
            closeOnConfirm: false
        }, ->
            Roles.addUsersToRoles self._id, 'member'
            swal "Made #{self.emails[0].address} an member", "",'success'
            return