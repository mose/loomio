import BaseRecordsInterface from '@/shared/record_store/base_records_interface'
import NotificationModel    from '@/shared/models/notification_model'
import _forEach from 'lodash/forEach'


export default class NotificationRecordsInterface extends BaseRecordsInterface
  model: NotificationModel

  viewed: ->
    any = false
    _forEach @collection.find(viewed: { $ne: true}), (n) =>
      any = true
      n.update(viewed: true)

    @remote.post 'viewed' if any
