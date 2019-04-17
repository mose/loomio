import _capitalize from 'lodash/capitalize'
import _uniq from 'lodash/uniq'
import _filter from 'lodash/filter'
import _union from 'lodash/union'
import _map from 'lodash/map'

export default new class HasDocuments
  apply: (model, opts = {}) ->
    model.newDocumentIds     = model.newDocumentIds or []
    model.removedDocumentIds = model.removedDocumentIds or []

    model.documents = ->
      model.recordStore.documents.find
        modelId: model.id
        modelType: _capitalize(model.constructor.singular)

    model.newDocuments = ->
      model.recordStore.documents.find(model.newDocumentIds)

    model.newAndPersistedDocuments = ->
      _uniq _filter _union(model.documents(), model.newDocuments()), (doc) ->
        !_includes model.removedDocumentIds, doc.id

    model.hasDocuments = ->
      model.newAndPersistedDocuments().length > 0

    model.serialize = ->
      data = @baseSerialize()
      root = model.constructor.serializationRoot or model.constructor.singular
      data[root].document_ids = _map model.newAndPersistedDocuments(), 'id'
      data

    model.showDocumentTitle = opts.showTitle
    model.documentsApplied = true
