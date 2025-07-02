# renovate-audit

For each repository in an organization, determine if:

1. A Renovate configuration is in place,
2. those Renovate pull requests are being (automatically) merged,
3. there is release tooling in place, and
4. that release tooling is automatic

## Usage

```console
% renovate-audit --help
Usage: renovate-audit [options]
        --org=ORG                    Organization to audit (default $GITHUB_REPOSITORY_OWNER)
        --exclude=NAME               Exclude repository by NAME
        --[no-]exit-code             Exit with code 1 if issues are found (default: true)
    -h, --help   
```

## GitHub Actions

See [../.github/workflows/audit.yml](../.github/workflows/audit.yml).

## Locally

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
