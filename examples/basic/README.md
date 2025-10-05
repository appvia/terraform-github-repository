# Terraform GitHub Repository - Basic Example

This example demonstrates how to use the `terraform-github-repository` module to create GitHub repositories with various configurations and features.

## Overview

This example creates three different types of repositories:

1. **Basic Repository** - A simple private repository with minimal configuration
2. **Advanced Repository** - A comprehensive repository with branch protection, environments, and collaborators
3. **Open Source Repository** - A public repository suitable for open source projects

## Features Demonstrated

### Repository Configuration

- Repository naming and description
- Visibility settings (private/public)
- Topics and categorization
- Homepage URL configuration
- Repository features (issues, projects, wiki, downloads, discussions)

### Security & Compliance

- Vulnerability alerts
- Signed commits requirement
- Branch protection rules
- Required status checks
- Pull request review requirements
- Environment protection

### Collaboration

- User and team collaborators
- Permission levels (read, write, admin)
- Review requirements
- Self-review prevention

### Merge Settings

- Merge commit options
- Rebase merge options
- Squash merge options
- Auto-merge configuration
- Branch deletion on merge

### Templates

- Repository template initialization
- Branch inclusion options

## Prerequisites

1. **GitHub Authentication**: You need a GitHub token with appropriate permissions
2. **Terraform**: Version >= 1.0.0
3. **GitHub Provider**: Version >= 6.0.0

### Required GitHub Permissions

Your GitHub token needs the following permissions:

- `repo` (Full control of private repositories)
- `admin:org` (if creating repositories in an organization)
- `user` (if creating personal repositories)

## Quick Start

1. **Clone and navigate to the example**:

   ```bash
   cd examples/basic
   ```

2. **Set up GitHub authentication**:

   ```bash
   export GITHUB_TOKEN="your-github-token"
   ```

3. **Customize the configuration**:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

4. **Initialize and apply**:

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Examples

### Basic Repository

```hcl
module "basic_repository" {
  source = "../../"

  repository = "my-basic-repo"
  description = "A basic example repository"
  visibility = "private"
  topics = ["terraform", "example", "basic"]

  # Enable basic features
  enable_issues = true
  enable_vulnerability_alerts = true

  # Merge settings
  allow_merge_commit = true
  allow_rebase_merge = true
  allow_squash_merge = true
  delete_branch_on_merge = true
}
```

### Advanced Repository with Branch Protection

```hcl
module "advanced_repository" {
  source = "../../"

  repository = "my-advanced-repo"
  description = "An advanced repository with comprehensive features"
  visibility = "private"

  # Branch protection
  branch_protection = {
    main = {
      branch = "main"
      enforce_admins = true
      require_conversation_resolution = true
      require_signed_commits = true

      required_status_checks = {
        strict = true
        checks = ["ci", "test", "security-scan"]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews = true
        required_approving_review_count = 2
      }
    }
  }

  # Environment protection
  environments = {
    production = {
      prevent_self_review = true
      reviewers = {
        users = ["senior-dev-1", "senior-dev-2"]
        teams = ["senior-developers"]
      }
    }
  }
}
```

### Open Source Repository

```hcl
module "open_source_repository" {
  source = "../../"

  repository = "my-open-source-repo"
  description = "An open source example repository"
  visibility = "public"
  topics = ["open-source", "terraform", "example"]

  # Open source friendly settings
  enable_issues = true
  enable_projects = true
  enable_wiki = true
  enable_discussions = true

  # Minimal branch protection
  branch_protection = {
    main = {
      branch = "main"
      enforce_admins = false
      require_conversation_resolution = true

      required_pull_request_reviews = {
        dismiss_stale_reviews = true
        required_approving_review_count = 1
      }
    }
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repository_name | Base name for the repositories to create | `string` | `"terraform-github-repository-example"` | no |
| collaborators | Basic collaborators for the repository | `list(object)` | `[]` | no |
| advanced_collaborators | Advanced collaborators with different permissions | `list(object)` | `[]` | no |
| branch_protection | Branch protection rules | `map(object)` | `{}` | no |
| environments | Environment protection rules | `map(object)` | `{}` | no |
| template | Template repository configuration | `object` | `null` | no |
| use_template | Whether to use a template repository | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| basic_repository | Basic repository information |
| advanced_repository | Advanced repository information |
| open_source_repository | Open source repository information |
| repository_security_settings | Security-related settings for all repositories |
| repository_urls | Quick access URLs for all repositories |
| summary | Summary of all created repositories |

## Usage Patterns

### Enterprise Development

For enterprise development teams, use the advanced repository configuration with:

- Strict branch protection rules
- Required status checks
- Multiple reviewers
- Environment protection
- Signed commits

### Open Source Projects

For open source projects, use the open source repository configuration with:

- Public visibility
- Minimal branch protection
- Community-friendly settings
- Wiki and discussions enabled

### Personal Projects

For personal projects, use the basic repository configuration with:

- Private visibility
- Simple branch protection
- Minimal collaboration requirements

## Best Practices

1. **Security**: Always enable vulnerability alerts and require signed commits for production repositories
2. **Collaboration**: Set up appropriate reviewers and prevent self-review for critical environments
3. **Branch Protection**: Use strict branch protection rules for main branches
4. **Status Checks**: Require passing CI/CD checks before merging
5. **Templates**: Use repository templates for consistent project structure

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure your GitHub token has the required permissions
2. **Repository Already Exists**: Check if a repository with the same name already exists
3. **Permission Denied**: Verify your token has access to the target organization/user
4. **Branch Protection Conflicts**: Ensure branch protection rules don't conflict with each other

### Debugging

Enable Terraform debug logging:

```bash
export TF_LOG=DEBUG
terraform apply
```

Check GitHub API rate limits:

```bash
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/rate_limit
```

## Cleanup

To destroy the created resources:

```bash
terraform destroy
```

**Warning**: This will delete all created repositories and their contents permanently.

## Contributing

When contributing to this example:

1. Test your changes with different configurations
2. Update documentation for new features
3. Ensure backward compatibility
4. Add appropriate validation rules
