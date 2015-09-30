JiraIssueSearchView = require './jira-issue-search-view'
{CompositeDisposable, ConfigObserver} = require 'atom'

module.exports = JiraIssueSearch =
  config:
    jiraSearchUrl:
      type        : 'string'
      description : 'Jira search REST url'
      default     : 'https://*.atlassian.net/rest/api/latest/search/'

  view: null
  subscriptions: null

  activate: (state) ->
    @view = new JiraIssueSearchView(state.myPackageViewState)
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace', 'jira-issue-search:search': => @search()

  deactivate: ->
    @subscriptions.dispose()

  search: ->
    @view.show()

  serialize: ->
