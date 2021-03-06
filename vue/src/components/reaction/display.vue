<script lang="coffee">
import Records from '@/shared/services/records'
import Session from '@/shared/services/session'
import {merge, capitalize, difference, keys, throttle, startsWith, each} from 'lodash'
import WatchRecords from '@/mixins/watch_records'
import { colonToUnicode, stripColons } from '@/shared/helpers/emojis'

export default
  mixins: [WatchRecords]
  props:
    model: Object
    load: Boolean

  data: ->
    diameter: 20
    maxNamesCount: 10
    loaded: !@load
    reactionHash: {all: []}

  mounted: ->
    @watchRecords
      collections: ['reactions']
      query: (store) =>
        @reactionHash = {all: []}
        each Records.reactions.find(@reactionParams), (reaction) =>
          unless @reactionHash[reaction.reaction]?
            @reactionHash[reaction.reaction] = []
          user = Records.users.find(reaction.userId)
          @reactionHash[reaction.reaction].push(user)
          @reactionHash['all'].push(user)
          true

    if @load
      Records.reactions.fetch(params:
        reactable_type: capitalize(@model.constructor.singular)
        reactable_id: @model.id
      ).finally => @loaded = true


  computed:
    reactionParams: ->
      reactableType: capitalize(@model.constructor.singular)
      reactableId: @model.id

    reactionTypes: ->
      difference keys(@reactionHash), ['all']

    myReaction: ->
      return unless Session.isSignedIn()
      Records.reactions.find(merge({}, @reactionParams, userId: Session.user().id))[0]

    otherReaction: ->
      Records.reactions.find(merge({}, @reactionParams, {userId: {'$ne': Session.user().id}}))[0]

    reactionTypes: ->
      difference keys(@reactionHash), ['all']

  methods:
    stripColons: stripColons
    colonToUnicode: colonToUnicode
    removeMine: (reaction) ->
      mine = Records.reactions.find(merge({}, @reactionParams,
        userId:   Session.user().id
        reaction: reaction
      ))[0]
      mine.destroy() if mine

    translate: (shortname) ->
      title = emojiTitle(shortname)
      if startsWith(title, "reactions.") then shortname else title

    countFor: (reaction) ->
      if @reactionHash[reaction]?
        @reactionHash[reaction].length - @maxNamesCount
      else
        0

</script>
<template lang="pug">
.reactions-display.lmo-flex.lmo-flex__center
  loading(v-if="!loaded" :diameter="diameter")
  .lmo-flex.lmo-flex__center(v-if="loaded")
    .reactions-display__emojis
      .reaction.lmo-pointer(@click="removeMine(reaction)" v-for="reaction in reactionTypes")
        v-tooltip(bottom)
          template(v-slot:activator="{ on }")
            .reactions-display__group(v-on="on")
              span {{colonToUnicode(reaction)}}
              //- span(v-if="reactionHash[reaction].length > 1") {{reactionHash[reaction].length}}
              //- span(v-if="reactionHash[reaction]") list present
              user-avatar.reactions-display__author(v-for="user in reactionHash[reaction]" :key="user.id" :user="user" size="tiny")
          .reactions-display__name(v-for="user in reactionHash[reaction]" :key="user.id")
            span {{ user.name }}
</template>

<style lang="scss">
.reactions-display__group {
  display: flex;
  align-items: center;
  margin-right: 2px;
  span {
    font-size: 20px;
  }
}
.reactions-display__emojis {
  display: flex;
}
</style>
