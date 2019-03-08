require('coffeescript/register')
pageHelper = require('../helpers/page_helper.coffee')

module.exports = {
  'allows members to modify their plan': (test) => {
    page = pageHelper(test)

    page.loadPath('setup_group_on_free_plan')
    page.click('.current-plan-button')
    page.expectText('.pricing-table__modal', 'Please upgrade for premium features')
  },

  'shows the subscription success modal': (test) => {
    page = pageHelper(test)

    page.loadPath('setup_group_after_chargify_success')
    page.expectText('.subscription-success-modal', 'Thanks for upgrading')
  }
}
