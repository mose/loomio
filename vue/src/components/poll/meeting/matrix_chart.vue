<style lang="scss">
</style>

<script lang="coffee">
import svg from 'svg.js'
import _each from 'lodash/each'
import _isEmpty from 'lodash/isEmpty'
import _times from 'lodash/times'
import _max from 'lodash/max'

export default
  props:
    matrixCounts: Array
    size: String
  data: ->
    svgEl: null
    shapes: []
  mounted: ->
    this.svgEl = svg(this.$el).size('100%', '100%')
    this.draw()
  methods:
    draw: ->
      _each this.shapes, (shape) -> shape.remove()
      if _isEmpty(this.matrixCounts)
        this.drawPlaceholder()
      else
        this.drawChart()
    drawChart: ->
      width = this.size / _max([this.matrixCounts.length, this.matrixCounts[0].length])
      _each this.matrixCounts, (values, row) =>
        _each values, (value, col) =>
          this.drawShape(row, col, width, value)
    drawPlaceholder: ->
      _each _times(5), (row) =>
        _each _times(5), (col) =>
          this.drawShape(row, col, this.size / 5, 0)
    drawShape: (row, col, width, value) ->
      color = ['#ebebeb','#f3b300','#00e572'][value]
      this.shapes.push(this.svgEl.circle(width-1)
        .fill(color)
        .x(width * row)
        .y(width * col))
  watch:
    stanceCounts: ->
      this.draw()
</script>

<template>
<div class="matrix-chart"></div>
</template>
