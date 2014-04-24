Backbone        = require 'backbone'
Backbone.$      = $
_               = require 'underscore'
HeaderView      = require './header/view.coffee'
FooterView      = require './footer/view.coffee'
sd              = require('sharify').data
analytics       = require '../../lib/analytics.coffee'
iframePopover   = require '../iframe_popover/index.coffee'

{ readCookie, createCookie } = require '../util/cookie.coffee'

module.exports = ->
  setupJquery()
  setupViews()
  setupReferrerTracking()

setupAnalytics = ->
  # Initialize analytics & track page view if we included mixpanel
  # (not included in test environment).
  return if not mixpanel? or mixpanel is 'undefined'
  analytics(mixpanel: mixpanel, ga: ga)
  analytics.trackPageview()

  # Log a visit once per session
  unless readCookie('active_session')?
    createCookie 'active_session', true
    analytics.track.funnel if sd.CURRENT_USER
      'Visited logged in'
    else
      'Visited logged out'

setupReferrerTracking = ->
  if document?.referrer?.indexOf and document.referrer.indexOf(sd.APP_URL) < 0 and readCookie('force-referrer') != document.referrer
    createCookie 'force-referrer', document.referrer
    createCookie 'force-session-start', window.location.pathname

setupViews = ->
  new HeaderView el: $('#main-layout-header'), $window: $(window), $body: $('body')
  new FooterView el: $('#main-layout-footer')

setupJquery = ->
  require '../../node_modules/typeahead.js/dist/typeahead.bundle.min.js'
  require 'jquery.transition'
  require 'jquery.fillwidth'
  require 'jquery.dotdotdot'
  require 'jquery.poplockit'
  require '../../lib/jquery/infinitescroll.coffee'
  require '../../lib/jquery/hidehover.coffee'
  $.ajaxSettings.headers =
    'X-XAPP-TOKEN'  : sd.ARTSY_XAPP_TOKEN
    'X-ACCESS-TOKEN': sd.CURRENT_USER?.accessToken

setupAnalytics()
