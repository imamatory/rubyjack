workflow "CI" {
  on = "push"
  resolves = ["test"]
}

action "test" {
  uses = "ci"
}
