# msa-architecture
msa Training cluster by python based language's server library for studying msa , ArgoCD , K8s , EFK 


## ⚠️ Please Read me ⚠️

### 1. You should change that part to your information 
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
 
>   #### or Just delete only that parts of code 😀
>
>   ```tf
>     backend "remote" {
>      organization = "codns" # must be changed
>      workspaces {
>        name = "msa_kube" # must be changed
>      }
>   ```

### 2. When you push a codes by your forked repository, you have to pull my `master` branches first 
### 3. Create branches for each function and push them to the corresponding branches!
### 4. Study whenever you can! 🐥

## Architecture
![image](kube_msa_architecture.drawio.png)
