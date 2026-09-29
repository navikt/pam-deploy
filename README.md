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
Workflows prefikset med `cd-` er del av continuous deployment. Disse bygger ett image og deployer det til `dev-gcp` og deretter `prod-gcp`, uten draft release. Prod deployes kun fra
`main`/`master` og kun hvis dev-deploy gikk ok. Prod-deployer vises under *Deployments* i repoet (GitHub environment `prod-gcp`).

| Fil | Innhold |
|---|---|
| `cd-build-deploy.yml` | `mise run build` + image → `cd-deploy.yml`; `codeql-mise.yml` og dependency graph parallelt (blokkerer ikke deploy) |
| `cd-deploy.yml` | felles deploy: dev → prod. Kan kalles direkte med `IMAGE` |
| `codeql-mise.yml` | CodeQL med mise. Kan også kalles direkte, f.eks. på `pull_request`/`schedule` (permissions: `contents: read`, `security-events: write`, `actions: read`) |
| `actions/build-image` | image + SBOM, Trivy-skann |

- **Bygg med [mise](https://mise.jdx.dev):** `mise.toml` i repo-roten må ha verktøy under `[tools]` og en `build`-task.
  Verktøy installeres og caches av mise; `mise.lock` brukes (`--locked`) hvis den finnes.
- **CodeQL-språk** utledes fra `[tools]`: `java` → java-kotlin, `node` → javascript-typescript.
  **Dependency graph** sendes inn for gradle eller maven (oppdaget fra `build.gradle[.kts]`/`settings.gradle[.kts]`/`pom.xml`).
- **Konvensjoner:** team `teampam`, `Dockerfile` i roten, GitHub environments `dev-gcp`/`prod-gcp`, og
  `nais apply` med [mixins](https://doc.nais.io/build/how-to/deploy-pipeline/): `.nais/app.yaml` + `.nais/app.<env>.yaml`.
- **Rekkefølge:** nyere kjøring på samme branch kansellerer eldre bygg, så prod får aldri et eldre image. Dev-deploy
  køes per branch; to branches kan dermed deploye til dev samtidig.

Ingen inputs. Valgfri secret: `READER_TOKEN` (tilgjengelig som env i `mise run build` og som build secret i Docker).

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
    uses: navikt/pam-deploy/.github/workflows/cd-build-deploy.yml@v9
    secrets:
      READER_TOKEN: ${{ secrets.READER_TOKEN }}
```
