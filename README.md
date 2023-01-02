# msa-architecture
msa Training cluster by python based language's server library for studying msa , ArgoCD , K8s , EFK 


### ⚠️ Please Read me ⚠️

in main.tf ...

You should change that part to your information 
```tf
terraform {
  backend "remote" {
    organization = "codns" # must be changed
    workspaces {
      name = "msa_kube" # must be changed
    }
  }
  ...
 ```
 
 or Just delete only that parts of code 😀
 
 ```tf
   backend "remote" {
    organization = "codns" # must be changed
    workspaces {
      name = "msa_kube" # must be changed
    }
 ```
 

### Architecture
![image](kube_msa_architecture.drawio.png)
