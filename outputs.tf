# GitHub Repository Module Outputs

output "repository_name" {
  description = "The name of the created repository"
  value       = github_repository.repository.name
}

output "repository_full_name" {
  description = "The full name of the created repository (owner/repo)"
  value       = github_repository.repository.full_name
}

output "repository_description" {
  description = "The description of the created repository"
  value       = github_repository.repository.description
}

output "repository_visibility" {
  description = "The visibility of the created repository"
  value       = github_repository.repository.visibility
}

output "repository_html_url" {
  description = "The HTML URL of the created repository"
  value       = github_repository.repository.html_url
}

output "repository_ssh_clone_url" {
  description = "The SSH clone URL of the created repository"
  value       = github_repository.repository.ssh_clone_url
}

output "repository_git_clone_url" {
  description = "The Git clone URL of the created repository"
  value       = github_repository.repository.git_clone_url
}

output "repository_topics" {
  description = "The topics applied to the repository"
  value       = github_repository.repository.topics
}

output "repository_vulnerability_alerts" {
  description = "Whether vulnerability alerts are enabled"
  value       = github_repository.repository.vulnerability_alerts
}

output "repository_allow_merge_commit" {
  description = "Whether merge commits are allowed"
  value       = github_repository.repository.allow_merge_commit
}

output "repository_allow_rebase_merge" {
  description = "Whether rebase merges are allowed"
  value       = github_repository.repository.allow_rebase_merge
}

output "repository_allow_squash_merge" {
  description = "Whether squash merges are allowed"
  value       = github_repository.repository.allow_squash_merge
}

output "repository_allow_auto_merge" {
  description = "Whether auto merges are allowed"
  value       = github_repository.repository.allow_auto_merge
}

output "repository_delete_branch_on_merge" {
  description = "Whether branches are deleted on merge"
  value       = github_repository.repository.delete_branch_on_merge
}
