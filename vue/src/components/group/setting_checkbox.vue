<script lang="coffee">
import _snakeCase from 'lodash/snakeCase'

export default
  props:
    group: Object
    setting: String
    translateValues: Boolean
  computed:
    translateKey: ->
      "group_form.#{_snakeCase(@setting)}"
</script>

<template>
    <div class="group-setting-checkbox">
      <v-checkbox v-model="group[setting]">
        <span v-t="{ path: translateKey, args: translateValues }"></span>
      </v-checkbox>
    </div>
</template>
