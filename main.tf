locals {
  ## Collaborators users
  collaborator_users = try(var.collaborators.users, {})
  ## Collaborators teams
  collaborator_teams = try(var.collaborators.teams, {})
  ## The total number of collaborators
  total_collaborators = length(local.collaborator_users) + length(local.collaborator_teams)
}


## Provision the repositories in github
resource "github_repository" "repository" {
  name                   = var.repository
  description            = var.description
  allow_auto_merge       = var.allow_auto_merge
  allow_merge_commit     = var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  has_discussions        = var.enable_discussions
  has_issues             = var.enable_issues
  has_projects           = var.enable_projects
  has_wiki               = var.enable_wiki
  homepage_url           = var.homepage_url
  archived               = var.enable_archived
  topics                 = var.topics
  visibility             = var.visibility
  vulnerability_alerts   = var.enable_vulnerability_alerts

  dynamic "template" {
    for_each = var.template != null ? [1] : toset([])
    content {
      owner                = var.template.owner
      repository           = var.template.repository
      include_all_branches = var.template.include_all_branches
    }
  }
}

## Provision the webhooks for the repository
resource "github_repository_webhook" "webhooks" {
  for_each = { for webhook in var.webhooks : webhook.url => webhook }

  active     = each.value.enable
  events     = each.value.events
  repository = github_repository.repository.name

  configuration {
    content_type = each.value.content_type
    insecure_ssl = each.value.insecure_ssl
    secret       = each.value.secret
    url          = each.value.url
  }
}

## Define the main branch
resource "github_branch" "default" {
  count = var.default_branch != null ? 1 : 0

  branch     = var.default_branch
  repository = github_repository.repository.name
}

## Associate the production enviroment with each of the repositories
resource "github_repository_environment" "environments" {
  for_each = var.environments

  environment         = each.key
  can_admins_bypass   = try(each.value.can_admins_bypass, null)
  prevent_self_review = try(each.value.prevent_self_review, null)
  repository          = github_repository.repository.name

  dynamic "reviewers" {
    for_each = each.value.reviewers != null ? [1] : []
    content {
      users = try(each.value.reviewers.users, null)
      teams = try(each.value.reviewers.teams, null)
    }
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

## Associate the branch protection with each of the repositories
resource "github_branch_protection" "branch_protection" {
  for_each = var.branch_protection

  pattern                         = each.key
  allows_force_pushes             = try(each.value.allows_force_pushes, null)
  allows_deletions                = try(each.value.allows_deletions, null)
  enforce_admins                  = try(each.value.enforce_admins, null)
  lock_branch                     = try(each.value.lock_branch, null)
  repository_id                   = github_repository.repository.node_id
  require_conversation_resolution = try(each.value.require_conversation_resolution, null)
  require_signed_commits          = try(each.value.require_signed_commits, null)
  required_linear_history         = try(each.value.required_linear_history, null)

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks != null ? [1] : []
    content {
      strict   = try(each.value.required_status_checks.strict, null)
      contexts = try(each.value.required_status_checks.contexts, null)
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews != null ? [1] : []
    content {
      dismiss_stale_reviews           = try(each.value.required_pull_request_reviews.dismiss_stale_reviews, null)
      dismissal_restrictions          = try(each.value.required_pull_request_reviews.dismissal_restrictions, null)
      pull_request_bypassers          = try(each.value.required_pull_request_reviews.pull_request_bypassers, null)
      require_code_owner_reviews      = try(each.value.required_pull_request_reviews.require_code_owner_reviews, null)
      require_last_push_approval      = try(each.value.required_pull_request_reviews.require_last_push_approval, null)
      required_approving_review_count = try(each.value.required_pull_request_reviews.required_approving_review_count, null)
      restrict_dismissals             = try(each.value.required_pull_request_reviews.restrict_dismissals, null)
    }
  }
}

## Associate any collaborators with the repository
resource "github_repository_collaborator" "users" {
  for_each = local.collaborator_users

  permission = each.value.permission
  repository = github_repository.repository.name
  username   = each.key
}

## Associate any collaborator teams with the repository
resource "github_team_repository" "teams" {
  for_each = local.collaborator_teams

  permission = each.value.permission
  repository = github_repository.repository.name  
  team_id    = each.key
}