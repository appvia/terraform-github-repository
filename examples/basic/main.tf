#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

# Create a basic repository with minimal configuration
module "basic_repository" {
  source = "../../"

  # Required variables
  repository = var.repository_name

  # Optional basic configuration
  description = "A basic example repository created with terraform-github-repository module"
  visibility  = "private"
  topics      = ["terraform", "example", "basic"]

  # Repository features
  enable_issues               = true
  enable_projects             = false
  enable_wiki                 = false
  enable_downloads            = false
  enable_discussions          = false
  enable_vulnerability_alerts = true

  # Merge settings
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = true
  # Default branch
  default_branch = "main"
  # Collaborators (optional)
  collaborators = var.collaborators
  # Branch protection (optional)
  branch_protection = var.branch_protection
  # Environments (optional)
  environments = var.environments
  # Template (optional)
  template = local.template_config
}

# Create an advanced repository with comprehensive configuration
module "advanced_repository" {
  source = "../../"

  # Required variables
  repository = "${var.repository_name}-advanced"

  # Advanced configuration
  description  = "An advanced example repository with comprehensive GitHub features"
  visibility   = "private"
  homepage_url = "https://example.com"
  topics       = ["terraform", "example", "advanced", "github-actions", "ci-cd"]

  # Repository features
  enable_issues               = true
  enable_projects             = true
  enable_wiki                 = true
  enable_downloads            = true
  enable_discussions          = true
  enable_vulnerability_alerts = true

  # Merge settings
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_auto_merge       = true
  delete_branch_on_merge = true

  # Default branch
  default_branch = "main"

  # Collaborators
  collaborators = var.advanced_collaborators

  # Branch protection with comprehensive rules
  branch_protection = {
    main = {
      branch                          = "main"
      enforce_admins                  = true
      require_conversation_resolution = true
      require_signed_commits          = true

      required_status_checks = {
        strict = true
        checks = ["ci", "test", "security-scan"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 2
        dismissal_users                 = ["admin-user"]
        dismissal_teams                 = ["admin-team"]

        bypass_pull_request_allowances = {
          users = ["bot-user"]
          teams = ["bot-team"]
        }
      }
    }

    develop = {
      branch                          = "develop"
      enforce_admins                  = true
      require_conversation_resolution = false
      require_signed_commits          = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 1
      }
    }
  }

  # Environments with protection rules
  environments = {
    production = {
      prevent_self_review = true
      can_admins_bypass   = false
      reviewers = {
        users = ["senior-dev-1", "senior-dev-2"]
        teams = ["senior-developers"]
      }
    }

    staging = {
      prevent_self_review = false
      can_admins_bypass   = true
      reviewers = {
        users = ["dev-1", "dev-2"]
        teams = ["developers"]
      }
    }

    development = {
      prevent_self_review = false
      can_admins_bypass   = true
    }
  }

  # Template from another repository
  template = local.template_config
}

# Create a public repository for open source projects
module "open_source_repository" {
  source = "../../"

  repository = "${var.repository_name}-open-source"

  description = "An open source example repository"
  visibility  = "public"
  topics      = ["open-source", "terraform", "example", "public"]

  # Open source friendly settings
  enable_issues               = true
  enable_projects             = true
  enable_wiki                 = true
  enable_downloads            = true
  enable_discussions          = true
  enable_vulnerability_alerts = true

  # Merge settings
  allow_merge_commit     = true
  allow_rebase_merge     = true
  allow_squash_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = true

  default_branch = "main"

  # Minimal branch protection for open source
  branch_protection = {
    main = {
      branch                          = "main"
      enforce_admins                  = false
      require_conversation_resolution = true
      require_signed_commits          = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 1
      }
    }
  }

  # No environments for open source
  environments = null
}
