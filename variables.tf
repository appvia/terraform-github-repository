variable "repository" {
  description = "The name of the repository to provision"
  type        = string

  validation {
    condition     = length(var.repository) > 0
    error_message = "The repository name must be greater than 0"
  }

  validation {
    condition     = length(var.repository) <= 100
    error_message = "The repository name must be less than or equal to 100"
  }
}

variable "description" {
  description = "The description of the repository to provision"
  type        = string
  default     = "Terraform AWS Pipeline"
}

variable "visibility" {
  description = "The visibility of the repository to provision"
  type        = string
  default     = "private"
}

variable "template" {
  description = "The template of the repository to provision"
  type = object({
    # The owner of the repository template
    owner = string
    # The repository template to use for the repository
    repository = string
    # Include all branches
    include_all_branches = optional(bool, false)
  })
  default = null
}

variable "delete_branch_on_merge" {
  description = "The delete branch on merge of the repository to provision"
  type        = bool
  default     = true
}

variable "default_branch" {
  description = "The default branch of the repository to provision"
  type        = string
  default     = null
}

variable "collaborators" {
  description = "The GitHub user or organization to create the repositories under"
  type = object({
    # User permissions to the repository. Can be one of: pull, triage, push, maintain, admin
    users = optional(map(object({
      # The permission of the collaborator
      permission = optional(string, "triage")
    })), {})
    teams = optional(map(object({
      # The permission of the collaborator
      permission = optional(string, "triage")
    })), {})
  })
  default = null
}

variable "enable_vulnerability_alerts" {
  description = "Indicates if vulnerability alerts are enabled within the repository"
  type        = bool
  default     = null
}

variable "enable_issues" {
  description = "Indicates if issues are enabled within the repository"
  type        = bool
  default     = true
}

variable "enable_projects" {
  description = "Indicates if projects are enabled within the repository"
  type        = bool
  default     = false
}

variable "enable_wiki" {
  description = "Indicates if wiki is enabled within the repository"
  type        = bool
  default     = false
}

variable "enable_discussions" {
  description = "Indicates if discussions are enabled within the repository"
  type        = bool
  default     = false
}

variable "homepage_url" {
  description = "The homepage URL of the repository to provision"
  type        = string
  default     = null
}

variable "enable_archived" {
  description = "Indicates if the repository is archived"
  type        = bool
  default     = false
}

variable "allow_merge_commit" {
  description = "Allow merge commits within repositories"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges within repositories"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merges within repositories"
  type        = bool
  default     = true
}

variable "allow_auto_merge" {
  description = "Allow auto merges within repositories"
  type        = bool
  default     = false
}

variable "branch_protection" {
  description = "The branch protection to use for the repository"
  type = map(object({
    # Indicates if force pushes are allowed for the branch
    allows_force_pushes = optional(bool, false)
    # Indicates if deletions are allowed for the branch
    allows_deletions = optional(bool, false)
    # Indicates if stale reviews are dismissed for the branch
    dismiss_stale_reviews = optional(bool, true)
    # Indicates if admins are included in the branch protection rules
    enforce_admins = optional(bool, true)
    # Indicates if the branch is locked
    lock_branch = optional(bool, false)
    # Indicates if conversation resolution is required for the branch
    require_conversation_resolution = optional(bool, false)
    # Indicates if the last push approval is required for the branch
    require_last_push_approval = optional(bool, false)
    # Indicates if signed commits are required for the branch
    require_signed_commits = optional(bool, true)
    # Indicates if linear history is required for the branch
    required_linear_history = optional(bool, false)

    # The required status checks which are required for the branch
    required_status_checks = optional(object({
      strict   = optional(bool, true)
      contexts = optional(list(string), null)
    }), null)

    # The required pull request reviews which are required for the branch
    required_pull_request_reviews = optional(object({
      # Indicates if stale reviews are dismissed
      dismiss_stale_reviews = optional(bool, true)
      # The dismissal restrictions which are required for the branch
      dismissal_restrictions = optional(list(string), null)
      # The pull request bypassers which are required for the branch
      pull_request_bypassers = optional(list(string), null)
      # Indicates if code owner reviews are required for the branch
      require_code_owner_reviews = optional(bool, true)
      # Indicates if the last push approval is required for the branch
      require_last_push_approval = optional(bool, false)
      # The required approving review count which is required for the branch
      required_approving_review_count = optional(number, 1)
      # Indicates if dismissals are restricted for the branch
      restrict_dismissals = optional(bool, false)
    }), null)
  }))
  default = {
    main = {
      allows_deletions                = false
      allows_force_pushes             = false
      dismiss_stale_reviews           = true
      enforce_admins                  = true
      lock_branch                     = false
      require_conversation_resolution = false
      require_last_push_approval      = false
      require_signed_commits          = true
      required_approving_review_count = 1
      required_linear_history         = false
      required_status_checks = {
        strict   = true
        contexts = null
      }
    }
  }
}

variable "webhooks" {
  description = "The webhooks to use for the repository"
  type = list(object({
    # The content type of the webhook
    content_type = optional(string, "json")
    # The URL of the webhook
    url = string
    # The enable flag of the webhook
    enable = optional(bool, true)
    # The events of the webhook
    events = optional(list(string), ["push", "pull_request"])
    # The insecure SSL flag of the webhook
    insecure_ssl = optional(bool, false)
    # The secret of the webhook
    secret = optional(string, null)
  }))
  default = []
}

variable "environments" {
  description = "The environments to use within repositories"
  type = map(object({
    # Ensures that the user cannot approve their own pull requests
    prevent_self_review = optional(bool, true)
    # Ensures that admins are subject to the environment's protection rules
    can_admins_bypass = optional(bool, false)
    # The reviewers to use for the environment
    reviewers = optional(object({
      users = optional(list(string), null)
      teams = optional(list(string), null)
    }), null)
  }))
  default = {}
}

variable "topics" {
  description = "The topics to apply to the repositories"
  type        = list(string)
  default     = ["aws", "terraform", "landing-zone"]
}
