<script lang="coffee">
import _slice from 'lodash/slice'
import _orderBy from 'lodash/orderBy'

export default
  props:
    query: Object
    limit:
      type: Number
      default: 25
    order:
      type: String
      default: '-lastActivityAt'
  data: ->
    threads: @query.threads()
  computed:
    orderedThreads: ->
      _slice(_orderBy(@threads, @order), 0, @limit)
</script>

<template lang="pug">
v-list.thread-previews(two-line)
  thread-preview(v-for="thread in orderedThreads", :key="thread.id", :thread="thread")
</template>
