import AppConfig from '@/shared/services/app_config.coffee'
import _find from 'lodash/find'

export pluginConfigFor = (name) ->
  _find(AppConfig.plugins.installed, (p) -> p.name == name).config
