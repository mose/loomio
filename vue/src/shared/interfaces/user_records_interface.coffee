import BaseRecordsInterface from '@/shared/record_store/base_records_interface'
import UserModel            from '@/shared/models/user_model'

import _merge from 'lodash/merge'
import _pickBy from 'lodash/pickBy'
import _identity from 'lodash/identity'

export default class UserRecordsInterface extends BaseRecordsInterface
  model: UserModel
  apiEndPoint: 'profile'

  fetchMentionable: (q, model) =>
    model = model.discussion() if !model.id? && model.discussionId
    model = model.group() if !model.id? && !model.discussionId
    @fetch
      path: 'mentionable_users'
      params:
        q: q
        "#{model.constructor.singular}_id": model.id

  updateProfile: (user) =>
    @remote.post 'update_profile', _merge(user.serialize(), {unsubscribe_token: user.unsubscribeToken })

  uploadAvatar: (file) =>
    @remote.upload 'upload_avatar', file

  changePassword: (user) =>
    @remote.post 'change_password', user.serialize()

  deactivate: (user) =>
    @remote.post 'deactivate', user.serialize()

  destroy: => @remote.delete '/'

  reactivate: (user) =>
    @remote.post 'reactivate', user.serialize()

  saveExperience: (experience) =>
    @remote.post 'save_experience', experience: experience

  emailStatus: (email, token) ->
    @fetch
      path: 'email_status'
      params: _pickBy({email: email, token: token}, _identity)
