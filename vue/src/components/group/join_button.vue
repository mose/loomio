<script lang="coffee">
import Session        from '@/shared/services/session'
import Records        from '@/shared/services/records'
import EventBus       from '@/shared/services/event_bus'
import AbilityService from '@/shared/services/ability_service'
import Flash   from '@/shared/services/flash'
import ModalService   from '@/shared/services/modal_service'
import AuthModalMixin from '@/mixins/auth_modal'
import GroupModalMixin from '@/mixins/group_modal'

export default
  mixins: [AuthModalMixin, GroupModalMixin]
  props:
    group: Object
    block: Boolean
  methods:
    askToJoinText: ->
      if @hasRequestedMembership()
        'join_group_button.membership_requested'
      else
        'join_group_button.ask_to_join_group'

    joinGroup: ->
      if Session.isSignedIn()
        Records.memberships.joinGroup(@group).then =>
          EventBus.$emit 'joinedGroup', {group: @group}
          Flash.success('join_group_button.messages.joined_group', group: @group.fullName)
      else
        @openAuthModal()

    requestToJoinGroup: ->
      if Session.isSignedIn()
        @openMembershipRequestModal(@group)
      else
        @openAuthModal()

  computed:
    isMember: ->
      Session.user().membershipFor(@group)?

    canJoinGroup: ->
      AbilityService.canJoinGroup(@group)

    canRequestMembership: ->
      AbilityService.canRequestMembership(@group)

    hasRequestedMembership: ->
      @group.hasPendingMembershipRequestFrom(Session.user())

    isLoggedIn: ->
      Session.isSignedIn()

  created: ->
    Records.membershipRequests.fetchMyPendingByGroup(@group.key)
</script>

<template lang="pug">
div(v-if="!isMember" class="join-group-button")
  div(v-if="canJoinGroup" class="blank")
    v-btn.join-group-button__join-group(v-t="'join_group_button.join_group'" @click="joinGroup()" class="md-raised md-primary join-group-button__join-group")
  div(v-if="canRequestMembership" class="blank")
    v-btn.join-group-button__ask-to-join-group(:disabled="hasRequestedMembership" v-t="'join_group_button.join_group'" @click="requestToJoinGroup()" class="md-raised md-primary join-group-button__ask-to-join-group")
</template>
