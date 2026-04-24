# Azure deployment design

This repository is deployed as a static web app using **Azure Static Web Apps**.

## Chosen Azure resources

- **Resource Group**: logical container for deployment assets.
- **Azure Static Web App (Standard SKU)**: hosts this static HTML/CSS app and provides production + staging environments.

## CI/CD flows

### 1) CI (`.github/workflows/ci.yml`)
Runs on pushes and pull requests.

Checks:
- Required files are present.
- Local dry-run by serving the site with `python3 -m http.server` and validating `index.html`/`index.css` response codes.

### 2) Infrastructure provisioning (`.github/workflows/provision-azure.yml`)
Manual workflow (`workflow_dispatch`) that:
- Authenticates with Azure using OIDC.
- Creates/updates a resource group.
- Deploys `infra/main.bicep` to create/update Azure Static Web App.

### 3) Deployment (`.github/workflows/deploy-azure-static-web-app.yml`)
Runs on push to `main` (and manual dispatch) to publish the static site.

## Required GitHub secrets and variables

### Secrets
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_STATIC_WEB_APPS_API_TOKEN`

### Repository variables
- `AZURE_RESOURCE_GROUP`
- `AZURE_STATIC_WEB_APP_NAME`

## One-time setup checklist

1. Create an Entra app registration + federated credential for GitHub OIDC.
2. Grant it `Contributor` on the target subscription or resource group.
3. Configure secrets and repository variables listed above.
4. Run **Provision Azure Infrastructure** workflow.
5. Retrieve SWA deployment token and set `AZURE_STATIC_WEB_APPS_API_TOKEN`.
6. Push to `main` to trigger deployment.
