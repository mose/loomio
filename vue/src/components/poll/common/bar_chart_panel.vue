<style lang="scss">
.poll-common-bar-chart {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.poll-common-bar-chart__bar {
  transition: background-size 0.1s ease-in-out;
  display: flex;
  align-items: center;
  min-width: 4px;
  min-height: 48px;
  margin-top: 10px;
  background-repeat: no-repeat;
  word-break: break-word;
  white-space: normal;
  line-height: 24px;
  width: 100%;
  padding: 0 8px;
}
</style>

<script lang="coffee">
import { fieldFromTemplate, myLastStanceFor } from '@/shared/helpers/poll'
import urlFor                                 from '@/mixins/url_for'
import _max from 'lodash/max'
import _values from 'lodash/values'
import _orderBy from 'lodash/orderBy'

export default
  mixins: [urlFor]
  props:
    poll: Object
  methods:
    countFor: (option) ->
      this.poll.stanceData[option.name] or 0
    barTextFor: (option) ->
      "#{this.countFor(option)} - #{option.name}".replace(/\s/g, '\u00a0')
    percentageFor: (option) ->
      max = _max(_values(this.poll.stanceData))
      return unless max > 0
      "#{100 * this.countFor(option) / max}%"
    backgroundImageFor: (option) ->
      "url(/img/poll_backgrounds/#{option.color.replace('#','')}.png)"
    styleData: (option) ->
      'background-image': this.backgroundImageFor(option)
      'background-size': "#{this.percentageFor(option)} 100%"
  computed:
    orderedPollOptions: ->
      _orderBy(this.poll.pollOptions(), ['priority'])
</script>

<template>
<div class="poll-common-bar-chart">
  <div
    v-for="option in orderedPollOptions"
    :key="option.id"
    :style="styleData(option)"
    class="poll-common-bar-chart__bar"
  >
    {{barTextFor(option)}}
  </div>
</div>
</template>
