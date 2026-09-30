# pam-deploy
Deploy scripts used by arbeidsplassen. 

Actions that wrap around nais deploy, to follow a github release workflow.

## Github release workflow
Github release workflow use github release events to implement an "Approved/promoted to production" 
workflow. On push to master, after the build, integration tests and deploy to test environment. It will then 
produce a changelog and create a github release draft. This can then be "published", the event will trigger 
the deploy to production github action.

An example that follow this release workflow and uses pam-deploy actions can be seen 
[here](https://github.com/navikt/pam-import-api/tree/master/.github/workflows)

## Continuous deployment workflow

```toml
# mise.toml
[tools]
java = "25"

[tasks.build]
run = "./gradlew test installDist"
```

```yaml
on:
  push:
    branches: [main]
jobs:
  build-deploy:
    permissions:
      contents: write
      id-token: write
      security-events: write
      actions: read
    secrets: inherit
    uses: navikt/pam-deploy@v9
```
