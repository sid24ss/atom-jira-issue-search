# Jira Issue Search

Package to search Jira issues and open browser to issue

## Screenshot
![Screenshot](https://raw.githubusercontent.com/samuliheljo/atom-jira-issue-search/master/img/screenshot.png)

## Demo
![Demo](https://raw.githubusercontent.com/samuliheljo/atom-jira-issue-search/master/img/demo.gif)

# Usage

In package settings Set up Jira REST url
- URL should be something like: https://{project}.atlassian.net/

To open search press
- OS X: cmd-shift-j
- Windows: ctrl-shift-j
- Linux: ctrl-shift-j

Type to make searches
- Press enter to open browser to selected issue

# What is searched?
Package searches using following filter:
- Status != Resolved
- Summary text
- Desciption text
- Comment text
- Issue id
