param natGateways_ASC_UKS_Test_vnet_ngw_name string = 'ASC-UKS-Test-vnet-ngw'
param publicIPAddresses_ASC_UKS_Test_vnet_ngw_pip_externalid string = '/subscriptions/cac2619a-f2d2-4480-b197-448cd18a7ade/resourceGroups/ASC-UKS-Test-vnet-rg/providers/Microsoft.Network/publicIPAddresses/ASC-UKS-Test-vnet-ngw-pip'

resource natGateways_ASC_UKS_Test_vnet_ngw_name_resource 'Microsoft.Network/natGateways@2022-11-01' = {
  name: natGateways_ASC_UKS_Test_vnet_ngw_name
  location: 'uksouth'
  tags: {
    Owner: 'Advanced Supply Chain'
    Application: 'Infrastructure'
    Criticality: 'Not Critical'
    Environment: 'Test'
    'Business Unit': 'Advanced Supply Chain'
    'Cost Centre': 'Advanced Supply Chain IT'
    LogicMonitorStatus: 'Include'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_ASC_UKS_Test_vnet_ngw_pip_externalid
      }
    ]
  }
}
