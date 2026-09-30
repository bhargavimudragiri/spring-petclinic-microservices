Write-Host "Configuring Petclinic EKS cluster..."

aws eks update-kubeconfig `
  --region us-east-1 `
  --name petclinic-eks `
  --profile petclinic-prod

kubectl apply -f cluster/storageclass-default.yaml

Write-Host "Cluster setup complete."
