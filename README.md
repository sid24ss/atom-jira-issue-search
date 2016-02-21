# Jira Issue Search

Package to search Jira issues and open browser to issue

## Screenshot
![Screenshot](https://raw.githubusercontent.com/samuliheljo/atom-jira-issue-search/master/img/screenshot.png)

## Demo
![Demo](https://raw.githubusercontent.com/samuliheljo/atom-jira-issue-search/master/img/demo.gif)

# Usage

1. In package settings Set up Jira REST url
URL should be something like: https://{project}.atlassian.net/

2. Press cmd-shift-j to open search box

3. Type to make searches

# What is searched?
Package searches using following filter:
- Status != Resolved
- Summary text
- Desciption text
- Comment text
- Issue id
