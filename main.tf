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
  has_downloads          = var.enable_downloads
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

## Define the main branch
resource "github_branch" "default" {
  branch     = var.default_branch
  repository = github_repository.repository.name
}

## Associate the production enviroment with each of the repositories
resource "github_repository_environment" "environments" {
  for_each = var.environments

  environment         = each.value
  prevent_self_review = each.value.prevent_self_review
  repository          = github_repository.repository.name

  dynamic "reviewers" {
    for_each = each.value.reviewers != null ? [1] : []
    content {
      users = each.value.reviewers.users
      teams = each.value.reviewers.teams
    }
  }

  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

## Associate the branch protection with each of the repositories
resource "github_branch_protection_v3" "branch_protection" {
  for_each = var.branch_protection

  branch                          = each.value.branch
  enforce_admins                  = each.value.enforce_admins
  repository                      = github_repository.repository.name
  require_conversation_resolution = each.value.require_conversation_resolution
  require_signed_commits          = each.value.require_signed_commits

  dynamic "required_status_checks" {
    for_each = each.value.required_status_checks != null ? [1] : []
    content {
      strict = each.value.required_status_checks.strict
      checks = each.value.required_status_checks.checks
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.required_pull_request_reviews != null ? [1] : []
    content {
      dismiss_stale_reviews           = each.value.required_pull_request_reviews.dismiss_stale_reviews
      dismissal_users                 = each.value.required_pull_request_reviews.dismissal_users
      dismissal_teams                 = each.value.required_pull_request_reviews.dismissal_teams
      dismissal_apps                  = each.value.required_pull_request_reviews.dismissal_apps
      required_approving_review_count = each.value.required_pull_request_reviews.required_approving_review_count

      dynamic "bypass_pull_request_allowances" {
        for_each = each.value.bypass_pull_request_allowances != null ? [1] : []
        content {
          users = each.value.bypass_pull_request_allowances.users
          teams = each.value.bypass_pull_request_allowances.teams
          apps  = each.value.bypass_pull_request_allowances.apps
        }
      }
    }
  }
}

## Associate any collaborators with the repositories
resource "github_repository_collaborator" "collaborators" {
  for_each = { for collaborator in var.collaborators : collaborator.username => collaborator }

  permission = each.value.permission
  repository = github_repository.repository.name
  username   = each.value.username
}
