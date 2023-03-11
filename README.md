# terraform-azure-instance-build-module
Generic terraform module for deploying Linux VM in Azure. 

### Usage Example
```
  source = "git::https://github.com/fkhademi/terraform-azure-instance-build-module.git?ref=nva0.1"

  name            = "frey"
  region          = "North Europe"
  rg              = "rg-av-frey-899789"
  vnet            = "frey"
  subnet          = "frey-Public-gateway-subnet-1"
  ssh_key         = var.ssh_key
  public_ip       = true
  cloud_init_data = ""
}

```

### Variables
The following variables are required:

key | value
:--- | :---
name | Azure resource name
region | Azure region
rg | Resource Group where resources should be deployed
vnet | VNET name
subnet | Subnet name where VM should be attached
ssh_key | Public key to be used

The following variables are optional:

key | default | value 
:---|:---|:---
instance_size | Standard_B1ls | The size of the Azure VM instance
cloud_init_data | | cloud init data
public_ip | false | set to true for a pub ip

### Outputs
This module will return the following outputs:

key | description
:---|:---
vm | The created VM as an object with all of it's attributes. This was created using the azurerm_virtual_machine resource.
nic | The created NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource.
public_ip | Public ip and its attributes