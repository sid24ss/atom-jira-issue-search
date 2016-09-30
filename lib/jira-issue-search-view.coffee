{SelectListView} = require 'atom-space-pen-views'
shell = require 'shell'
_ = require 'lodash'
$ = require 'jquery'

module.exports = class JiraIssueSearchSelectListView extends SelectListView

  initialize: ->
    super
    # Initialize with dummy data to avoid "Loading icon" from appearing
    @setItems("")
    @addClass('overlay from-top')

  viewForItem: (item) ->
    status = if item.assignee then "#{item.status} - #{item.assignee}" else "#{item.status}"
    "<li class='two-lines'>
      <div class='primary-line'>#{item.desc}</div>
      <div class='secondary-line'>#{item.key}<span class='pull-right key-binding'>#{status}</span></div>
    </li>"

  confirmed: (item) ->
    shell.openExternal(item.url)

  cancelled: ->
    @hide()

  show: ->
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @focusFilterEditor()
    @jiraRestUrl = atom.config.get("jira-issue-search.jiraSearchUrl")
    @authKey = atom.config.get("jira-issue-search.authToken")
    @SEARCH_PATH = "/rest/api/latest/search"
    @VIEW_PATH = "/browse/"

  hide: ->
    @panel.hide()

  # overridden populateList that fetches data from Jira
  # This is not an optimal solution as SelectListView documentation
  # says that overridden populateList-method should always call super
  # However, that way it seems hard (impossible?) to get this working
  populateList: ->
    q = @getFilterQuery()
    if q.length < 2 then return

    # We must query issue id if we are sure that it's in right format
    issueIdPattern = /^([\w.]+)-(\d+)$/i;
    issueIdQuery = if q.match(issueIdPattern) then "or issue = #{q}" else ""
    jql = "status != Resolved and (summary~\"#{q}\" or description~\"#{q}\" or comment~\"#{q}\" #{issueIdQuery})"
    $.ajax
      url: "#{@jiraRestUrl}#{@SEARCH_PATH}?jql=#{jql}"
      beforeSend: (xhr) =>
        xhr.withCredentials = true
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
        xhr.setRequestHeader("Authorization", "Basic #{@authKey}")
      success: (data) =>
        issues = _.map data.issues, (issue) =>
          assignee = if issue.fields.assignee then issue.fields.assignee.displayName else null
          'key': issue.key
          'desc': issue.fields.summary
          'url': "#{@jiraRestUrl}#{@VIEW_PATH}#{issue.key}"
          'status': issue.fields.status.name
          'assignee': assignee

        @list.empty()
        if issues.length > 0
          @setError(null)
          for i in [0...Math.min(issues.length, @maxItems)]
            item = issues[i]
            itemView = $(@viewForItem(item))
            itemView.data('select-list-item', item)
            @list.append(itemView)
          @selectItemView(@list.find('li:first'))
      error: () ->
        atom.notifications.addError("Error executing search. Ensure that you have configured Jira url correctly. It should be something like: https://xxx.atlassian.net/")
