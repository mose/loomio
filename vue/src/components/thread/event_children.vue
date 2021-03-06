<style lang="scss">
.thread-item--indent {
  margin-left: 42px;
}
.event-children__un-indent {
  margin-left: -42px;
}
</style>

<script lang="coffee">
import AppConfig         from '@/shared/services/app_config'
import EventBus          from '@/shared/services/event_bus'
import NestedEventWindow from '@/shared/services/nested_event_window'
import WatchRecords from '@/mixins/watch_records'
import RecordLoader from '@/shared/services/record_loader'

export default
  mixins: [WatchRecords]
  props:
    parentEvent: Object
    parentEventWindow: Object

  components:
    ThreadItem: -> import('@/components/thread/item')

  data: ->
    eventWindow: null
    events: []
    loader: null

  created: ->
    @eventWindow = new NestedEventWindow
      parentEvent:       @parentEvent
      discussion:        @parentEventWindow.discussion
      initialSequenceId: @parentEventWindow.initialSequenceId
      per:               @parentEventWindow.per

    @loader = new RecordLoader
      collection: 'events'
      params:
        discussion_id: @parentEventWindow.discussion.id
        parent_id: @parentEvent.id
        order: 'position'
        per: @parentEventWindow.per

    @watchRecords
      collections: ['events']
      query: (store) =>
        @events = @eventWindow.windowedEvents()

  methods:
    loadPrevious: ->
      @eventWindow.decreaseMin()
      @loader.loadPrevious(@eventWindow.min)

    loadNext: ->
      @eventWindow.increaseMax()
      @loader.loadMore(@eventWindow.lastLoaded()+1) if @eventWindow.canLoadNext()

    debug: -> AppConfig.debug
</script>

<template lang="pug">
.event-children
  div(v-if='debug()')
    | event-childrenparentId: {{eventWindow.parentEvent.id}}cc: {{eventWindow.parentEvent.childCount}}min: {{eventWindow.min}}max: {{eventWindow.max}}first: {{eventWindow.firstLoaded()}}last: {{eventWindow.lastLoaded()}}anyPrevious: {{eventWindow.anyPrevious()}}anyNext: {{eventWindow.anyNext()}}
  a.activity-card__load-more.lmo-no-print.thread-item--indent-margin(v-show='eventWindow.anyPrevious() && !loader.loadingPrevious', @click='loadPrevious()')
    v-icon mdi-autorenew
    span(v-t="{ path: 'activity_card.n_previous', args: { count: eventWindow.numPrevious() } }")
  loading.activity-card__loading.page-loading(v-show='loader.loadingPrevious')
  thread-item(v-for='event in events' :key='event.id' :event-window='eventWindow' :event='event')
  a.activity-card__load-more.lmo-no-print.thread-item--indent-margin(v-show='eventWindow.anyNext() && !loader.loadingMore', @click='loadNext()')
    v-icon mdi-autorenew
    span(v-t="{ path: 'activity_card.n_more', args: { count: eventWindow.numNext() } }")
  loading.activity-card__loading.page-loading(v-show='loader.loadingMore')
</template>
