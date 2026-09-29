Write-Host "Setting up Petclinic monitoring..."

Write-Host "Installing Prometheus..."

helm upgrade --install prometheus prometheus-community/prometheus `
  -f monitoring/prometheus-values.yaml

Write-Host "Installing Grafana Operator..."

helm upgrade --install grafana-operator `
  oci://ghcr.io/grafana/helm-charts/grafana-operator `
  --version 5.25.0

Write-Host "Waiting for Grafana Operator to be ready..."

kubectl rollout status deployment/grafana-operator `
  --timeout=120s

Write-Host "Creating or updating Grafana dashboard ConfigMap..."

kubectl create configmap petclinic-dashboard `
  --from-file=petclinic-kubernetes-monitoring.json=monitoring/petclinic-kubernetes-monitoring.json `
  --dry-run=client -o yaml |
kubectl apply -f -

Write-Host "Configuring Grafana..."

kubectl apply -f monitoring/grafana-instance.yaml
kubectl apply -f monitoring/grafana-datasource.yaml
kubectl apply -f monitoring/grafana-dashboard.yaml

Write-Host "Petclinic monitoring setup complete."
