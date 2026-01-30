# GitHub Repository Module

This Terraform module creates and configures GitHub repositories with comprehensive security, collaboration, and automation features. It's designed to enforce best practices for repository management across different use cases.

## Features

### Repository Management

- **Repository Creation**: Create GitHub repositories with customizable names, descriptions, and visibility
- **Branch Management**: Configure default branches and branch protection rules
- **Repository Templates**: Support for GitHub repository templates to standardize project setup
- **Topics Management**: Apply consistent topics for better organization and discoverability

### Security & Compliance

- **Branch Protection**: Enforce branch protection rules with configurable requirements
- **Required Reviews**: Configure pull request review requirements and approval counts
- **Status Checks**: Require specific CI/CD status checks before merging
- **Signed Commits**: Enforce signed commits for enhanced security
- **Vulnerability Alerts**: Automatically enable GitHub's vulnerability scanning
- **Self-Review Prevention**: Prevent users from approving their own pull requests

### Collaboration & Access Control

- **Collaborator Management**: Add users with specific permission levels
- **Environment Protection**: Configure deployment environments with reviewer requirements
- **Bypass Allowances**: Configure emergency bypass rules for critical situations
- **Review Dismissal**: Configure who can dismiss reviews and under what conditions

### Merge Strategies

- **Flexible Merge Options**: Support for merge commits, rebase merges, and squash merges
- **Auto-merge Support**: Enable automatic merging when conditions are met
- **Branch Cleanup**: Automatically delete branches after merging

## Usage

### Basic Usage

```hcl
module "my_repository" {
  source = "github.com/appvia/terraform-github-repository"

  repository  = "my-project"
  description = "My awesome project"
  visibility  = "private"
  topics      = ["terraform", "example"]
}
```

### Advanced Usage

```hcl
module "enterprise_repository" {
  source = "github.com/appvia/terraform-github-repository"

  repository  = "enterprise-critical-system"
  description = "Enterprise critical system with strict controls"

  # Repository settings
  visibility     = "private"
  default_branch = "main"

  # Security settings
  enable_vulnerability_alerts = true

  # Merge settings
  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_squash_merge     = true
  allow_auto_merge       = false
  delete_branch_on_merge = true

  # Branch protection with comprehensive rules
  branch_protection = {
    main = {
      enforce_admins                  = true
      require_conversation_resolution = true
      require_signed_commits          = true
      allows_force_pushes             = false
      allows_deletions                = false

      required_status_checks = {
        strict = true
        contexts = [
          "CI / Build and Test",
          "Security / Security Scan",
          "Compliance / Compliance Check"
        ]
      }

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        require_code_owner_reviews      = true
        require_last_push_approval      = false
        required_approving_review_count = 3
        pull_request_bypassers          = ["emergency-user"]
        restrict_dismissals             = false
      }
    }
  }

  # Environments with protection rules
  environments = {
    production = {
      prevent_self_review = true
      can_admins_bypass   = false
      reviewers = {
        users = ["senior-dev1", "senior-dev2"]
        teams = ["platform-team", "security-team"]
      }
    }
    staging = {
      prevent_self_review = true
      can_admins_bypass   = true
      reviewers = {
        users = ["senior-dev1"]
        teams = ["platform-team"]
      }
    }
  }

  # Collaborators
  collaborators = [
    {
      username   = "senior-dev1"
      permission = "admin"
    },
    {
      username   = "junior-dev1"
      permission = "write"
    }
  ]

  # Topics
  topics = ["enterprise", "terraform", "aws", "critical"]
}
```

### Repository with Template

```hcl
module "templated_repository" {
  source = "github.com/appvia/terraform-github-repository"

  repository  = "my-new-project"
  description = "Repository created from template"
  visibility  = "private"

  # Use a template repository
  template = {
    owner                = "my-org"
    repository           = "project-template"
    include_all_branches = false
  }

  topics = ["terraform", "from-template"]
}
```

### Open Source Repository

```hcl
module "open_source_repository" {
  source = "github.com/appvia/terraform-github-repository"

  repository  = "my-open-source-project"
  description = "An open source project"
  visibility  = "public"
  topics      = ["open-source", "terraform", "public"]

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
  delete_branch_on_merge = true

  # Minimal branch protection for open source
  branch_protection = {
    main = {
      enforce_admins                  = false
      require_conversation_resolution = true
      require_signed_commits          = false

      required_pull_request_reviews = {
        dismiss_stale_reviews           = true
        required_approving_review_count = 1
      }
    }
  }
}
```

## Examples

This module is designed to work with different repository types:

- **Basic Repositories**: Standard development repositories with common security settings
- **Public Repositories**: Open source projects with appropriate public settings
- **Enterprise Repositories**: Highly controlled repositories with strict security policies

See the `examples/` directory for complete working examples.

## Security Features

This module implements several security best practices:

- **Branch Protection**: Enforces branch protection rules to prevent direct pushes to protected branches
- **Required Reviews**: Configures pull request review requirements
- **Status Checks**: Requires CI/CD status checks before merging
- **Signed Commits**: Enforces signed commits for enhanced security
- **Vulnerability Scanning**: Automatically enables GitHub's vulnerability alerts
- **Access Control**: Manages collaborator permissions and environment protection

## Best Practices

- Use environment protection for production deployments
- Require multiple reviewers for critical repositories
- Enable vulnerability alerts for all repositories
- Use repository templates to standardize project setup
- Regularly review and audit collaborator access
- Configure appropriate bypass allowances for emergency situations

## License

This module is part of the terraform-aws-landing-zones project and follows the same license terms.

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 6.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_repository"></a> [repository](#input\_repository) | The name of the repository to provision | `string` | n/a | yes |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Allow auto merges within repositories | `bool` | `false` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Allow merge commits within repositories | `bool` | `true` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Allow rebase merges within repositories | `bool` | `true` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Allow squash merges within repositories | `bool` | `true` | no |
| <a name="input_branch_protection"></a> [branch\_protection](#input\_branch\_protection) | The branch protection to use for the repository | <pre>map(object({<br/>    # Indicates if force pushes are allowed for the branch<br/>    allows_force_pushes = optional(bool, false)<br/>    # Indicates if deletions are allowed for the branch<br/>    allows_deletions = optional(bool, false)<br/>    # Indicates if stale reviews are dismissed for the branch<br/>    dismiss_stale_reviews = optional(bool, true)<br/>    # Indicates if admins are included in the branch protection rules<br/>    enforce_admins = optional(bool, true)<br/>    # Indicates if the branch is locked<br/>    lock_branch = optional(bool, false)<br/>    # Indicates if conversation resolution is required for the branch<br/>    require_conversation_resolution = optional(bool, false)<br/>    # Indicates if the last push approval is required for the branch<br/>    require_last_push_approval = optional(bool, false)<br/>    # Indicates if signed commits are required for the branch<br/>    require_signed_commits = optional(bool, true)<br/>    # Indicates if linear history is required for the branch<br/>    required_linear_history = optional(bool, false)<br/><br/>    # The required status checks which are required for the branch<br/>    required_status_checks = optional(object({<br/>      strict   = optional(bool, true)<br/>      contexts = optional(list(string), null)<br/>    }), null)<br/><br/>    # The required pull request reviews which are required for the branch<br/>    required_pull_request_reviews = optional(object({<br/>      # Indicates if stale reviews are dismissed<br/>      dismiss_stale_reviews = optional(bool, true)<br/>      # The dismissal restrictions which are required for the branch<br/>      dismissal_restrictions = optional(list(string), null)<br/>      # The pull request bypassers which are required for the branch<br/>      pull_request_bypassers = optional(list(string), null)<br/>      # Indicates if code owner reviews are required for the branch<br/>      require_code_owner_reviews = optional(bool, true)<br/>      # Indicates if the last push approval is required for the branch<br/>      require_last_push_approval = optional(bool, false)<br/>      # The required approving review count which is required for the branch<br/>      required_approving_review_count = optional(number, 1)<br/>      # Indicates if dismissals are restricted for the branch<br/>      restrict_dismissals = optional(bool, false)<br/>    }), null)<br/>  }))</pre> | <pre>{<br/>  "main": {<br/>    "allows_deletions": false,<br/>    "allows_force_pushes": false,<br/>    "dismiss_stale_reviews": true,<br/>    "enforce_admins": true,<br/>    "lock_branch": false,<br/>    "require_conversation_resolution": false,<br/>    "require_last_push_approval": false,<br/>    "require_signed_commits": true,<br/>    "required_approving_review_count": 1,<br/>    "required_linear_history": false,<br/>    "required_status_checks": {<br/>      "contexts": null,<br/>      "strict": true<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | The GitHub user or organization to create the repositories under | <pre>list(object({<br/>    # The username of the collaborator<br/>    username = string<br/>    # The permission of the collaborator<br/>    permission = optional(string, "write")<br/>  }))</pre> | `[]` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The default branch of the repository to provision | `string` | `null` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | The delete branch on merge of the repository to provision | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the repository to provision | `string` | `"Terraform AWS Pipeline"` | no |
| <a name="input_enable_archived"></a> [enable\_archived](#input\_enable\_archived) | Indicates if the repository is archived | `bool` | `false` | no |
| <a name="input_enable_discussions"></a> [enable\_discussions](#input\_enable\_discussions) | Indicates if discussions are enabled within the repository | `bool` | `false` | no |
| <a name="input_enable_issues"></a> [enable\_issues](#input\_enable\_issues) | Indicates if issues are enabled within the repository | `bool` | `true` | no |
| <a name="input_enable_projects"></a> [enable\_projects](#input\_enable\_projects) | Indicates if projects are enabled within the repository | `bool` | `false` | no |
| <a name="input_enable_vulnerability_alerts"></a> [enable\_vulnerability\_alerts](#input\_enable\_vulnerability\_alerts) | Indicates if vulnerability alerts are enabled within the repository | `bool` | `null` | no |
| <a name="input_enable_wiki"></a> [enable\_wiki](#input\_enable\_wiki) | Indicates if wiki is enabled within the repository | `bool` | `false` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | The environments to use within repositories | <pre>map(object({<br/>    # Ensures that the user cannot approve their own pull requests<br/>    prevent_self_review = optional(bool, true)<br/>    # Ensures that admins are subject to the environment's protection rules<br/>    can_admins_bypass = optional(bool, false)<br/>    # The reviewers to use for the environment<br/>    reviewers = optional(object({<br/>      users = optional(list(string), null)<br/>      teams = optional(list(string), null)<br/>    }), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | The homepage URL of the repository to provision | `string` | `null` | no |
| <a name="input_template"></a> [template](#input\_template) | The template of the repository to provision | <pre>object({<br/>    # The owner of the repository template<br/>    owner = string<br/>    # The repository template to use for the repository<br/>    repository = string<br/>    # Include all branches<br/>    include_all_branches = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | The topics to apply to the repositories | `list(string)` | <pre>[<br/>  "aws",<br/>  "terraform",<br/>  "landing-zone"<br/>]</pre> | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | The visibility of the repository to provision | `string` | `"private"` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | The webhooks to use for the repository | <pre>list(object({<br/>    # The content type of the webhook<br/>    content_type = optional(string, "json")<br/>    # The URL of the webhook<br/>    url = string<br/>    # The enable flag of the webhook<br/>    enable = optional(bool, true)<br/>    # The events of the webhook<br/>    events = optional(list(string), ["push", "pull_request"])<br/>    # The insecure SSL flag of the webhook<br/>    insecure_ssl = optional(bool, false)<br/>    # The secret of the webhook<br/>    secret = optional(string, null)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository_allow_auto_merge"></a> [repository\_allow\_auto\_merge](#output\_repository\_allow\_auto\_merge) | Whether auto merges are allowed |
| <a name="output_repository_allow_merge_commit"></a> [repository\_allow\_merge\_commit](#output\_repository\_allow\_merge\_commit) | Whether merge commits are allowed |
| <a name="output_repository_allow_rebase_merge"></a> [repository\_allow\_rebase\_merge](#output\_repository\_allow\_rebase\_merge) | Whether rebase merges are allowed |
| <a name="output_repository_allow_squash_merge"></a> [repository\_allow\_squash\_merge](#output\_repository\_allow\_squash\_merge) | Whether squash merges are allowed |
| <a name="output_repository_delete_branch_on_merge"></a> [repository\_delete\_branch\_on\_merge](#output\_repository\_delete\_branch\_on\_merge) | Whether branches are deleted on merge |
| <a name="output_repository_description"></a> [repository\_description](#output\_repository\_description) | The description of the created repository |
| <a name="output_repository_full_name"></a> [repository\_full\_name](#output\_repository\_full\_name) | The full name of the created repository (owner/repo) |
| <a name="output_repository_git_clone_url"></a> [repository\_git\_clone\_url](#output\_repository\_git\_clone\_url) | The Git clone URL of the created repository |
| <a name="output_repository_html_url"></a> [repository\_html\_url](#output\_repository\_html\_url) | The HTML URL of the created repository |
| <a name="output_repository_name"></a> [repository\_name](#output\_repository\_name) | The name of the created repository |
| <a name="output_repository_ssh_clone_url"></a> [repository\_ssh\_clone\_url](#output\_repository\_ssh\_clone\_url) | The SSH clone URL of the created repository |
| <a name="output_repository_topics"></a> [repository\_topics](#output\_repository\_topics) | The topics applied to the repository |
| <a name="output_repository_visibility"></a> [repository\_visibility](#output\_repository\_visibility) | The visibility of the created repository |
| <a name="output_repository_vulnerability_alerts"></a> [repository\_vulnerability\_alerts](#output\_repository\_vulnerability\_alerts) | Whether vulnerability alerts are enabled |
<!-- END_TF_DOCS -->