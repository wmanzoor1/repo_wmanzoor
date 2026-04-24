@description('Azure location for resources')
param location string = resourceGroup().location

@description('Environment suffix used in tags')
param environmentName string = 'prod'

@description('Global unique Azure Static Web App name')
param staticWebAppName string

@description('GitHub repository URL for linking metadata')
param repositoryUrl string = 'https://github.com/your-org/repo_wmanzoor'

resource staticSite 'Microsoft.Web/staticSites@2023-12-01' = {
  name: staticWebAppName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  tags: {
    environment: environmentName
    managedBy: 'github-actions'
    workload: 'task-points-web'
  }
  properties: {
    repositoryUrl: repositoryUrl
    branch: 'main'
    provider: 'GitHub'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
  }
}

output staticWebAppId string = staticSite.id
output staticWebAppDefaultHostName string = staticSite.properties.defaultHostname
