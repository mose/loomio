<script lang="coffee">
import AuthService  from '@/shared/services/auth_service'
import { hardReload } from '@/shared/helpers/window'
import Session from '@/shared/services/session'
import AuthModalMixin from '@/mixins/auth_modal'
import Flash from '@/shared/services/flash'
import EventBus from '@/shared/services/event_bus'

export default
  mixins: [AuthModalMixin]
  props:
    user: Object
  data: ->
    vars: {}
  methods:
    signIn: ->
      # EventBus.emit $scope, 'processing'
      @user.name = @vars.name if @vars.name?
      onSuccess = (data) =>
        Session.apply(data)
        @closeModal()
        EventBus.$emit('signedIn')
        Flash.success('auth_form.signed_in')
      finished = ->
        console.log 'doneProcessing'
        # EventBus.emit $scope, 'doneProcessing';
        # $scope.$apply();
      AuthService.signIn(@user, onSuccess, finished).finally finished

    signInAndSetPassword: ->
      LmoUrlService.params('set_password', true)
      @signIn()

    sendLoginLink: ->
      # EventBus.emit $scope, 'processing'
      AuthService.sendLoginLink(@user).finally ->
        # EventBus.emit $scope, 'doneProcessing'
        console.log 'doneProcessing'

    submit: ->
      if @user.hasPassword or @user.hasToken
        @signIn()
      else
        @sendLoginLink()
</script>
<template lang="pug">
.auth-signin-form
  auth-avatar(:user='user')
  .auth-signin-form__magic-link
    h2.lmo-h2.align-center(v-t="{ path: 'auth_form.welcome_back', args: { name: user.firstName() } }")
  .auth-signin-form__token.align-center(v-if='user.hasToken')
    validation-errors(:subject='user', field='token')
    v-btn.md-primary.md-raised.auth-signin-form__submit(@click='submit()', v-if='!user.errors.token')
      span(v-t="{ path: 'auth_form.sign_in_as', args: {name: user.name}}")
    v-btn.md-primary.md-raised.auth-signin-form__submit(@click='sendLoginLink()', v-if='user.errors.token')
      span(v-t="'auth_form.login_link'")
    p
      span(v-t="'auth_form.set_password_helptext'")
      a.lmo-pointer(@click='signInAndSetPassword()', v-t="'auth_form.set_password'")
  .auth-signin-form__no-token(v-if='!user.hasToken')
    p
      span(v-t="'auth_form.login_link_helptext'", v-if='!user.hasPassword')
      span(v-t="'auth_form.login_link_helptext_with_password'", v-if='user.hasPassword')
    .auth-signin-form__password(v-if='user.hasPassword')
      .md-block
        label(v-t="'auth_form.password'")
        v-text-field#password.lmo-primary-form-input(name='password', type='password', md-autofocus='true', ng-required='ng-required', v-model='user.password')
        validation-errors(:subject='user', field='password')
      .lmo-md-actions
        v-btn.auth-signin-form__login-link(@click='sendLoginLink()', :class="{'md-primary': !user.password}")
          span(v-t="'auth_form.login_link'")
        v-btn.md-primary.md-raised.auth-signin-form__submit(@click='submit()', :disabled='!user.password', v-if='user.hasPassword')
          span(v-t="'auth_form.sign_in'")
    .auth-signin-form__no-password(v-if='!user.hasPassword')
      .lmo-md-actions
        div
        v-btn.md-primary.md-raised.auth-signin-form__submit(@click='sendLoginLink()')
          span(v-t="'auth_form.login_link'")
</template>
<style lang="scss">
</style>
