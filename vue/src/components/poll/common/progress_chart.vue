<style lang="scss">
@import 'variables';

.progress-chart {
  background-color: $background-color;
  width: 50px;
  height: 50px;
}
</style>

<script lang="coffee">
import svg from 'svg.js'
import AppConfig from '@/shared/services/app_config'
import _each from 'lodash/each'
import _sum from 'lodash/sum'
import _max from 'lodash/sum'

export default
  props:
    stanceCounts: Array
    goal: Number
    size: String # IK: seems bad
  data: ->
    svgEl: null
  methods:
    draw: ->
      y = 0
      _each this.stanceCounts, (count, index) =>
        height = (this.size * _max([parseInt(count), 0])) / this.goal
        this.svgEl.rect(this.size, height)
            .fill(AppConfig.pollColors.count[index])
            .x(0)
            .y(this.size - height - y)
        y += height

      this.svgEl.circle(this.size / 2)
          .fill("#fff")
          .x(this.size / 4)
          .y(this.size / 4)
      this.svgEl.text((_sum(this.stanceCounts) || 0).toString())
          .font(size: 16, anchor: 'middle')
          .x(this.size / 2)
          .y((this.size / 4) + 3)
  watch:
    stanceCounts: -> this.draw()
  mounted: ->
    this.svgEl = svg(this.$el).size('100%', '100%')
    this.draw()

</script>

<template>
<div class="progress-chart"></div>
</template>
