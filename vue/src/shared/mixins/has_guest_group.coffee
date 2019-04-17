import _compact from 'lodash/compact'
import _map from 'lodash/map'
import _invokeMap from 'lodash/invokeMap'

export default new class HasGuestGroup
  apply: (model) ->
    model.guestGroup = ->
      @recordStore.groups.find(@guestGroupId)

    model.groupIds = model.groupIds or ->
      _compact [model.groupId, model.guestGroupId]

    model.groups = model.groups or ->
      @recordStore.groups.find(id: {$in: model.groupIds()})

    model.memberIds = model.memberIds or ->
      _map @recordStore.memberships.find(groupId: {$in: model.groupIds()}), 'userId'

    model.members = model.members or ->
      @recordStore.users.find(id: {$in: model.memberIds()})

    model.memberships = model.memberships or ->
      model.guestGroup().memberships().concat((model.group() or @recordStore.groups.build()).memberships())

    model.adminMemberships = ->
      model.guestGroup().adminMemberships().concat((model.group() or @recordStore.groups.build()).adminMemberships())

    model.adminMembers = ->
      _invokeMap model.adminMemberships(), 'user'
