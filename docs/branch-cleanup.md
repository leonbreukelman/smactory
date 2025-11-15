# Branch Cleanup

This document explains how to delete all branches except `main` in the repository.

## Automated Cleanup with GitHub Actions

A GitHub Actions workflow has been created to automate branch cleanup. This workflow will delete all branches except `main`.

### How to Run the Workflow

1. Navigate to the GitHub repository in your web browser
2. Click on the "Actions" tab
3. Select "Cleanup Branches" from the list of workflows on the left sidebar
4. Click the "Run workflow" button on the right side
5. Select the branch (typically `main`) and click "Run workflow"
6. The workflow will execute and delete all branches except `main`

### What the Workflow Does

The workflow:
- Fetches all remote branches
- Identifies all branches except `main`
- Deletes each branch using the GitHub API
- Provides a summary of deleted branches

### Manual Branch Deletion (Alternative)

If you prefer to delete branches manually using the command line:

```bash
# List all remote branches
git branch -r

# Delete a specific branch
git push origin --delete <branch-name>

# Example: Delete the copilot/delete-all-repo-content branch
git push origin --delete copilot/delete-all-repo-content
```

### Protected Branches

If any branches are protected, they cannot be deleted by this workflow or manual deletion. You would need to:
1. Go to repository Settings > Branches
2. Remove branch protection rules
3. Then run the cleanup workflow or delete manually

## Workflow File Location

The workflow is located at `.github/workflows/cleanup-branches.yml`
