#####################################################################################
# Variables for the basic example
# These demonstrate the various configuration options available
#####################################################################################

variable "repository_name" {
  description = "Base name for the repositories to create"
  type        = string
  default     = "terraform-github-repository-example"

  validation {
    condition     = length(var.repository_name) > 0
    error_message = "Repository name must not be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.repository_name))
    error_message = "Repository name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "collaborators" {
  description = "Basic collaborators for the repository"
  type = list(object({
    username   = string
    permission = optional(string, "write")
  }))
  default = [
    {
      username   = "example-user-1"
      permission = "write"
    },
    {
      username   = "example-user-2"
      permission = "read"
    }
  ]
}

variable "advanced_collaborators" {
  description = "Advanced collaborators with different permissions"
  type = list(object({
    username   = string
    permission = optional(string, "write")
  }))
  default = [
    {
      username   = "senior-dev-1"
      permission = "admin"
    },
    {
      username   = "senior-dev-2"
      permission = "admin"
    },
    {
      username   = "dev-1"
      permission = "write"
    },
    {
      username   = "dev-2"
      permission = "write"
    },
    {
      username   = "reviewer-1"
      permission = "read"
    }
  ]
}

variable "branch_protection" {
  description = "Branch protection rules for basic repository"
  type = map(object({
    branch                          = string
    enforce_admins                  = optional(bool, true)
    require_conversation_resolution = optional(bool, false)
    require_signed_commits          = optional(bool, false)

    required_status_checks = optional(object({
      strict = optional(bool, true)
      checks = optional(list(string), null)
    }), null)

    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews           = optional(bool, true)
      dismissal_users                 = optional(list(string), null)
      dismissal_teams                 = optional(list(string), null)
      dismissal_apps                  = optional(list(string), null)
      required_approving_review_count = optional(number, 1)

      bypass_pull_request_allowances = optional(object({
        users = optional(list(string), null)
        teams = optional(list(string), null)
        apps  = optional(list(string), null)
      }), null)
    }), null)
  }))
  default = {
    main = {
      branch                          = "main"
      enforce_admins                  = true
      require_conversation_resolution = true
      require_signed_commits          = true

      required_status_checks = {
        strict = true
        checks = ["ci", "test"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 1
      }
    }
  }
}

variable "environments" {
  description = "Environments for the repository"
  type = map(object({
    prevent_self_review = optional(bool, true)
    can_admins_bypass   = optional(bool, false)
    reviewers = optional(object({
      users = optional(list(string), null)
      teams = optional(list(string), null)
    }), null)
  }))
  default = {
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
  }
}

# Example of using a template
variable "use_template" {
  description = "Whether to use a template repository"
  type        = bool
  default     = false
}

# Conditional template based on use_template variable
locals {
  template_config = var.use_template ? {
    owner                = "github"
    repository           = "actions-starter-workflows"
    include_all_branches = false
  } : null
}
