resource Vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
    name: 'Vnet'
    location: 'uksouth'
    properties: {
      addressSpace: {
        addressPrefixes: [
          '172.16.0.0/16'
        ]
      }
      subnets: [
        {
          name: 'subnet1'
          properties: {
            addressPrefix: '172.16.1.0/24'
          }
        }
        {
          name: 'subnet2'
          properties: {
            addressPrefix: '172.16.2.0/24'
          }
        }
      ]
    }
  }

  resource Nic1 'Microsoft.Network/networkInterfaces@2021-02-01' = {
    name: 'Nic1'
    location: 'uksouth'
    dependsOn: [
      Vnet
    ]
    properties: {
      ipConfigurations: [
        {
          name: 'myIpConfig'
          properties: {
            subnet: {
              id: '${Vnet.id}/subnets/Subnet1'
            }
            privateIPAllocationMethod: 'Dynamic'
          }
        }
      ]
    }
  }
  
  resource VirtualMachine1 'Microsoft.Compute/virtualMachines@2021-03-01' = {
    name: 'VM1'
    location: 'uksouth'
    dependsOn: [
      Nic1
    ]
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_B2s'
      }
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-Datacenter'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
        }
      }
      osProfile: {
        computerName: 'VM1'
        adminUsername: 'adminuser'
        adminPassword: 'G@nesh003'
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: Nic1.id
          }
        ]
      }
    }
  }

  resource Nic2 'Microsoft.Network/networkInterfaces@2021-02-01' = {
    name: 'Nic2'
    location: 'uksouth'
    dependsOn: [
      Vnet
    ]
    properties: {
      ipConfigurations: [
        {
          name: 'myIpConfig'
          properties: {
            subnet: {
              id: '${Vnet.id}/subnets/Subnet2'
            }
            privateIPAllocationMethod: 'Dynamic'
          }
        }
      ]
    }
  }
  
  resource vm2 'Microsoft.Compute/virtualMachines@2021-03-01' = {
    name: 'VM2'
    location: 'uksouth'
    dependsOn: [
      Nic2
    ]
    properties: {
      hardwareProfile: {
        vmSize: 'Standard_B2s'
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
        }
      }
      osProfile: {
        computerName: 'VM2'
        adminUsername: 'adminuser'
        adminPassword: 'G@nesh003'
        linuxConfiguration: {
          disablePasswordAuthentication: false
        }
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: Nic2.id
          }
        ]
      }
    }
  }
  