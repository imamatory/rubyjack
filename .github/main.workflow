workflow "Check master" {
  on = "push"
  resolves = ["new-action"]
}

action "Filters for GitHub Actions" {
  uses = "actions/bin/filter@d820d56839906464fb7a57d1b4e1741cf5183efa"
}

action "new-action" {
  uses = "owner/repo/path@ref"
  needs = ["Filters for GitHub Actions"]
}
