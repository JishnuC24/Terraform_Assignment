module "rgroup-3065" {
  source = "./modules/rgroup-3065"

   resource_group_name = var.resource_group_name
   location = var.location 

   common_tags = local.common_tags

}

module "network-3065" {
  source = "./modules/network-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location
  
  vnet_name = var.vnet_name
  subnet_name = var.subnet_name
  nsg_name = var.nsg_name

  common_tags = local.common_tags
}

module "common-3065" {
  source = "./modules/common-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location

  common_tags = local.common_tags
}

module "vmlinux-3065" {
  source = "./modules/vmlinux-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location
  
  subnet_id =  module.network-3065.subnet_id
  storage_account_uri = module.common-3065.storage_account-primary_blob_endpoint
  
  common_tags = local.common_tags
}

module "vmwindows-3065" {
  source = "./modules/vmwindows-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location
  
  subnet_id =  module.network-3065.subnet_id
  storage_account_uri = module.common-3065.storage_account-primary_blob_endpoint
  
  common_tags = local.common_tags
}

module "datadisk-3065" {
  source = "./modules/datadisk-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location

  linux_vm_ids        = module.vmlinux-3065.vmlinux.ids 
  windows_vm_ids      = module.vmwindows-3065.windows.ids
  
  all_vm_ids = concat(module.vmlinux-3065.vmlinux.ids, module.vmwindows-3065.windows.ids) 
  common_tags = local.common_tags
}

module "loadbalancer-3065" {
  source              = "./modules/loadbalancer-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location
 
  linux_vm_nic_ids	      =	module.vmlinux-3065.vmlinux-nic-ids
  linux_vm_name           = module.vmlinux-3065.vmlinux.hostnames
  common_tags = local.common_tags
}

module "database-3065" {
  source                       = "./modules/database-3065"
  
  resource_group_name = module.rgroup-3065.resource_group_name
  location = module.rgroup-3065.location

  common_tags = local.common_tags
}
