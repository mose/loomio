import _capitalize from 'lodash/capitalize'
import _forEach from 'lodash/forEach'

export default new class HasMentions
  apply: (model, field) ->
    methodName = "cooked#{_capitalize(field)}"
    fieldName  = "#{methodName}Value"
    model[methodName] = ->
      if @[fieldName]
        @[fieldName]
      else
      cooked = model[field]
      _forEach model.mentionedUsernames, (username) ->
        cooked = cooked.replace(///@#{username}///g, "[[@#{username}]]")
      @[fieldName] = cooked
