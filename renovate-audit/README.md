# renovate-audit

For each repository in an organization, determine if:

1. A Renovate configuration is in place,
2. those Renovate pull requests are being (automatically) merged,
3. there is release tooling in place, and
4. that release tooling is automatic

## Usage

Install any Ruby dependencies:

```console
bundle
```

Set some variables so we quack like GitHub Actions,

```console
export GITHUB_TOKEN=$(gh auth token)
export GITHUB_REPOSITORY_OWNER=freckle
```

Run the thing,

```console
bundle exec renovate-audit
```

> [!NOTE] This should all occur within the `renovate-audit` sub-directory where
> this README lives.
