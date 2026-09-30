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
# .github/workflows/main.yml
on:
  push:
    branches: [main]
  workflow_dispatch:
jobs:
  build-deploy:
    permissions:
      contents: read
      id-token: write
      security-events: write
      actions: read
    uses: navikt/pam-deploy/.github/workflows/build-deploy.yml@v9
    # (optional) secrets to build the app
    secrets:
      READER_TOKEN: ${{ secrets.READER_TOKEN }}
```

The image is built and deployed on `push` and `workflow_dispatch`. Pull requests only build and test. Add
`workflow_dispatch` to the caller's triggers to allow manual redeploys, or to deploy after merges made with
`GITHUB_TOKEN` (such as Dependabot auto-merge), since those don't trigger `push` workflows.

For repos with multiple apps, list each app's folder at the repo root in a matrix. The folder name becomes
the image suffix, and `<folder>/Dockerfile` is built with the repo root as context.

Each app has its own `mise.toml` and `.nais/` in its folder. The build task runs from the app's folder, so Gradle
only builds that app and the modules it depends on. `buildNeeded` also runs the tests of those modules.

```toml
# app-a/mise.toml
[tools]
java = "25"

[tasks.build]
run = "../gradlew buildNeeded"
```

```dockerfile
# app-a/Dockerfile
COPY app-a/build/libs/app-a-all.jar /app.jar
```

```yaml
# .github/workflows/main.yml
jobs:
  build-deploy:
    strategy:
      fail-fast: false
      matrix:
        app: [app-a, app-b]
    uses: navikt/pam-deploy/.github/workflows/build-deploy.yml@v9
    with:
      working_directory: ${{ matrix.app }}
```
