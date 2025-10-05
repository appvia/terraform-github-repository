#####################################################################################
# Outputs for the basic example
# These demonstrate the various outputs available from the module
#####################################################################################

# Basic Repository Outputs
output "basic_repository" {
  description = "Basic repository information"
  value = {
    name        = module.basic_repository.repository_name
    full_name   = module.basic_repository.repository_full_name
    description = module.basic_repository.repository_description
    visibility  = module.basic_repository.repository_visibility
    html_url    = module.basic_repository.repository_html_url
    ssh_url     = module.basic_repository.repository_ssh_clone_url
    git_url     = module.basic_repository.repository_git_clone_url
    topics      = module.basic_repository.repository_topics
  }
}

# Advanced Repository Outputs
output "advanced_repository" {
  description = "Advanced repository information"
  value = {
    name        = module.advanced_repository.repository_name
    full_name   = module.advanced_repository.repository_full_name
    description = module.advanced_repository.repository_description
    visibility  = module.advanced_repository.repository_visibility
    html_url    = module.advanced_repository.repository_html_url
    ssh_url     = module.advanced_repository.repository_ssh_clone_url
    git_url     = module.advanced_repository.repository_git_clone_url
    topics      = module.advanced_repository.repository_topics
  }
}

# Open Source Repository Outputs
output "open_source_repository" {
  description = "Open source repository information"
  value = {
    name        = module.open_source_repository.repository_name
    full_name   = module.open_source_repository.repository_full_name
    description = module.open_source_repository.repository_description
    visibility  = module.open_source_repository.repository_visibility
    html_url    = module.open_source_repository.repository_html_url
    ssh_url     = module.open_source_repository.repository_ssh_clone_url
    git_url     = module.open_source_repository.repository_git_clone_url
    topics      = module.open_source_repository.repository_topics
  }
}

# Repository Security Settings
output "repository_security_settings" {
  description = "Security-related settings for all repositories"
  value = {
    basic = {
      vulnerability_alerts   = module.basic_repository.repository_vulnerability_alerts
      allow_merge_commit     = module.basic_repository.repository_allow_merge_commit
      allow_rebase_merge     = module.basic_repository.repository_allow_rebase_merge
      allow_squash_merge     = module.basic_repository.repository_allow_squash_merge
      allow_auto_merge       = module.basic_repository.repository_allow_auto_merge
      delete_branch_on_merge = module.basic_repository.repository_delete_branch_on_merge
    }
    advanced = {
      vulnerability_alerts   = module.advanced_repository.repository_vulnerability_alerts
      allow_merge_commit     = module.advanced_repository.repository_allow_merge_commit
      allow_rebase_merge     = module.advanced_repository.repository_allow_rebase_merge
      allow_squash_merge     = module.advanced_repository.repository_allow_squash_merge
      allow_auto_merge       = module.advanced_repository.repository_allow_auto_merge
      delete_branch_on_merge = module.advanced_repository.repository_delete_branch_on_merge
    }
    open_source = {
      vulnerability_alerts   = module.open_source_repository.repository_vulnerability_alerts
      allow_merge_commit     = module.open_source_repository.repository_allow_merge_commit
      allow_rebase_merge     = module.open_source_repository.repository_allow_rebase_merge
      allow_squash_merge     = module.open_source_repository.repository_allow_squash_merge
      allow_auto_merge       = module.open_source_repository.repository_allow_auto_merge
      delete_branch_on_merge = module.open_source_repository.repository_delete_branch_on_merge
    }
  }
}

# Repository URLs for easy access
output "repository_urls" {
  description = "Quick access URLs for all repositories"
  value = {
    basic_repository_html = module.basic_repository.repository_html_url
    basic_repository_ssh  = module.basic_repository.repository_ssh_clone_url
    basic_repository_git  = module.basic_repository.repository_git_clone_url

    advanced_repository_html = module.advanced_repository.repository_html_url
    advanced_repository_ssh  = module.advanced_repository.repository_ssh_clone_url
    advanced_repository_git  = module.advanced_repository.repository_git_clone_url

    open_source_repository_html = module.open_source_repository.repository_html_url
    open_source_repository_ssh  = module.open_source_repository.repository_ssh_clone_url
    open_source_repository_git  = module.open_source_repository.repository_git_clone_url
  }
}

# Summary of created repositories
output "summary" {
  description = "Summary of all created repositories"
  value = {
    total_repositories = 3
    repositories = [
      {
        name        = module.basic_repository.repository_name
        visibility  = module.basic_repository.repository_visibility
        description = "Basic example repository"
        url         = module.basic_repository.repository_html_url
      },
      {
        name        = module.advanced_repository.repository_name
        visibility  = module.advanced_repository.repository_visibility
        description = "Advanced example repository with comprehensive features"
        url         = module.advanced_repository.repository_html_url
      },
      {
        name        = module.open_source_repository.repository_name
        visibility  = module.open_source_repository.repository_visibility
        description = "Open source example repository"
        url         = module.open_source_repository.repository_html_url
      }
    ]
  }
}
