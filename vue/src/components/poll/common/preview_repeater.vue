<script lang="coffee">
import _sortBy from 'lodash/sortBy'
export default
  props:
    pollsPage: Object
    displayGroupName: Boolean
  computed:
    orderedPolls: ->
      _sortBy(@pollsPage.pollCollection.polls(), @pollsPage.pollImportance)

</script>

<template>
    <div>
      {{ orderedPolls }}
      <poll-common-preview
        v-for="poll in orderedPolls"
        :key="poll.id"
        :poll="poll"
        :display-group-name="displayGroupName"
      ></poll-common-preview>
    </div>
</template>
