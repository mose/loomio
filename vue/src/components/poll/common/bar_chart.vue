<style lang="scss">
.bar-chart {
  border: 0;
  margin: 0;
  padding: 0;
  width: 50px;
  height: 50px;
}

.bar-chart svg {
   height: 100%;
   width: 100%;
}
</style>

<script lang="coffee">
import svg from 'svg.js'
import AppConfig from '@/shared/services/app_config'
import _take from 'lodash/take'
import _map from 'lodash/map'
import _max from 'lodash/max'
import _each from 'lodash/each'

export default
  props:
    stanceCounts: Array
    size: String # IK: seems bad
  data: ->
    svgEl: null
    shapes: []
  computed:
    scoreData: ->
      _take(_map(this.stanceCounts, (score, index) ->
        { color: AppConfig.pollColors.poll[index], index: index, score: score }), 5)
    scoreMaxValue: ->
      _max _map(this.scoreData, (data) -> data.score)
  methods:
    draw: ->
      if this.scoreData.length > 0 and this.scoreMaxValue > 0
        this.drawChart()
      else
        this.drawPlaceholder()
    drawPlaceholder: ->
      _each this.shapes, (shape) -> shape.remove()
      barHeight = this.size / 3
      barWidths =
        0: this.size
        1: 2 * this.size / 3
        2: this.size / 3
      _each barWidths, (width, index) =>
        this.svgEl.rect(width, barHeight - 2)
            .fill("#ebebeb")
            .x(0)
            .y(index * barHeight)
    drawChart: ->
      _each this.shapes, (shape) -> shape.remove()
      barHeight = this.size / this.scoreData.length
      _map this.scoreData, (scoreDatum) =>
        barWidth = _max([(this.size * scoreDatum.score) / this.scoreMaxValue, 2])
        this.svgEl.rect(barWidth, barHeight-2)
            .fill(scoreDatum.color)
            .x(0)
            .y(scoreDatum.index * barHeight)
  watch:
    stanceCounts: ->
      this.draw()
  mounted: ->
    this.svgEl = svg(this.$el).size('100%', '100%')
    this.draw()
</script>

<template>
<div class="bar-chart"></div>
</template>
