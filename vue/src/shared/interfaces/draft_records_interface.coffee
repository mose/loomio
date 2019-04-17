import BaseRecordsInterface from '@/shared/record_store/base_records_interface'
import DraftModel           from '@/shared/models/draft_model'

import _head from 'lodash/head'
import _capitalize from 'lodash/capitalize'

export default class DraftRecordsInterface extends BaseRecordsInterface
  model: DraftModel

  findOrBuildFor: (model) ->
    _head(@find(draftableType: _capitalize(model.constructor.singular), draftableId: model.id)) or
    @build(draftableType: _capitalize(model.constructor.singular), draftableId: model.id, payload: {})

  fetchFor: (model) ->
    @remote.get "#{model.constructor.singular}/#{model.id}"
