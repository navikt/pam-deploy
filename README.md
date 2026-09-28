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
`main`/`master` og kun hvis dev-deploy gikk ok. Etter prod-deploy tagges commiten.

| Fil | Innhold |
|---|---|
| `cd-build-deploy-java.yml` / `cd-build-deploy-node.yml` | bygg + image → `cd-deploy.yml`; CodeQL parallelt (blokkerer ikke deploy) |
| `cd-deploy.yml` | felles deploy: dev → prod + git-tag. Kan kalles direkte med `IMAGE` og `VERSION_TAG` |
| `actions/build-image` | versjonstag, image + SBOM, Trivy-skann |

- **Byggeverktøy** oppdages fra repo-roten: gradle (`build.gradle[.kts]`/`settings.gradle[.kts]`) eller maven (`pom.xml`),
  pnpm (`pnpm-lock.yaml`) eller npm (`package-lock.json`). Feiler ved ingen eller flere treff, og for yarn.
- **Konvensjoner:** team `teampam`, `Dockerfile` i roten, GitHub environments `dev-gcp`/`prod-gcp`, og
  `nais apply` med [mixins](https://doc.nais.io/build/how-to/deploy-pipeline/): `.nais/app.yaml` + `.nais/app.<env>.yaml`.
- **Rekkefølge:** nyere kjøring på samme branch kansellerer eldre bygg, så prod får aldri et eldre image. Dev-deploy
  køes per branch; to branches kan dermed deploye til dev samtidig.
- `deploy-rollback.yml` bruker fortsatt `NAIS_RESOURCE`/`NAIS_VARS`, ikke mixins.

Inputs: `BUILD_SCRIPT` (default `./build.sh`), `JAVA_VERSION` (`25`, temurin) / `NODE_VERSION` (`22`).
Valgfri secret: `READER_TOKEN`.

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
    uses: navikt/pam-deploy/.github/workflows/cd-build-deploy-java.yml@v9 # eller cd-build-deploy-node.yml
    secrets:
      READER_TOKEN: ${{ secrets.READER_TOKEN }}
```
