# Cluster automation
### Configure kubectl based GKE access
* Install and setup `gcloud` command line tool.
* Check or export `KUBECONFIG` env variable that will point to the kubeconfig file.
* RUN `gcloud container clusters get-crendentials <cluster-name> --project [project-id]`
> By default it will be written to $HOME/kube/.config file. In case of multiple files 
> the first one is used.
