import AppConfig from '@/shared/services/app_config'
import _pick from 'lodash/pick'
import _snakeCase from 'lodash/snakeCase'
import _omit from 'lodash/omit'
import _isEmpty from 'lodash/isEmpty'
import _invokeMap from 'lodash/invokeMap'
import _capitalize from 'lodash/capitalize'

export default new class HasDrafts
  apply: (model) ->
    model.draftParent = model.draftParent or ->
      model[model.constructor.draftParent]()

    model.draft = ->
      return unless parent = model.draftParent()
      model.recordStore.drafts.findOrBuildFor(parent)

    model.draftFields = ->
       _pick model, model.constructor.draftPayloadAttributes

    model.fetchDraft = ->
      return unless parent = model.draftParent()
      model.recordStore.drafts.fetchFor(parent)

    model.fetchAndRestoreDraft = ->
      model.fetchDraft().then(model.restoreDraft) if model.draftParent()

    model.restoreDraft = ->
      return unless draft = model.draft()
      payloadField = _snakeCase(model.constructor.serializationRoot or model.constructor.singular)
      model.update _omit(draft.payload[payloadField], _isEmpty)

    model.resetDraft = ->
      return unless draft = model.draft()
      draft.updateFrom(model.recordStore[model.constructor.plural].build())

    model.updateDraft = ->
      return unless draft = model.draft()
      draft.updateFrom(model)

    model.clearDrafts = ->
      return unless parent = model.draftParent()
      _invokeMap model.recordStore.drafts.find(
        draftableType: _capitalize(parent.constructor.singular)
        draftableId:   parent.id
      ), 'remove'

    model.cancelDraftFetch = ->
      clearTimeout(model.draftFetch) if model.draftFetch

    model.planDraftFetch = ->
      model.cancelDraftFetch()
      model.draftFetch = setTimeout(model.updateDraft, AppConfig.drafts.debounce)

    model.hasDrafts = true
