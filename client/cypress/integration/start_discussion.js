Cypress.Cookies.debug(true)
Cypress.Cookies.preserveOnce('_loomio')

describe('start discussion', function() {
  it('successfully loads', function() {
    // cy.visit('/dev/setup_group')
    cy.request('/dev/setup_group')
    .then((res) => {
      // expect(res.redirects)
      cy.visit(res.allRequestResponses[1]['Request URL'])
    })
  })
})
