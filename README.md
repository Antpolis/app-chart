# Antpolis Application Helm Chart

This Helm chart deploys a Node.js application with configurable components including ingress, persistence, configmaps, and secrets.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- Nginx Ingress Controller
- Cert-manager (for SSL certificates)

## Installation

```bash
# Install the chart directly from GitHub
helm install my-release git+https://github.com/Antpolis/app-chart.git

# Install with custom values
helm install my-release git+https://github.com/Antpolis/app-chart.git -f my-values.yaml

# Or first clone the repository
git clone https://github.com/Antpolis/app-chart.git
cd app-chart
helm install my-release . -f my-values.yaml
```

## Configuration

The following table lists the configurable parameters of the chart and their default values.

### Application Configuration

| Parameter | Description | Allowed Values | Default |
|-----------|-------------|----------------|---------|
| `antpolis.type` | Type of application | `nodejs-app`, `dotnet-app`, `java-app`, `nextJS`, `vue` | `"nodejs-app"` |
| `antpolis.deploymentType` | Deployment type | `"helm"` | `"helm"` |
| `antpolis.layer` | Application layer | `api-backend`, `frontend`, `grpc-backend` | `"api-backend"` |
| `app.url` | Application URL | Any valid domain | `nil` |
| `app.environment` | Environment name | `prod`, `staging`, `dev`, `tipsy`, `stable` | `nil` |
| `app.port` | Application port | `nil` |

### Docker Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `docker.repo` | Docker image repository | `nil` |
| `docker.tag` | Docker image tag | `nil` |
| `docker.imagePullSecrets` | Image pull secrets | `[{name: "dockerhub"}]` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.className` | Ingress class name | `"nginx"` |
| `ingress.annotations` | Ingress annotations | See values.yaml |
| `ingress.domains` | List of ingress domains | See values.yaml |

### Persistence Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `persistence.enabled` | Enable persistence | `false` |
| `persistence.volumes` | Persistence volume configurations | See values.yaml |

### ConfigMap Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `configMap.enabled` | Enable ConfigMap | `false` |
| `configMap.value.files` | ConfigMap files | `{}` |
| `configMap.value.env` | ConfigMap environment variables | `{}` |

### Secrets Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `secrets.enabled` | Enable Secrets | `false` |
| `secrets.value` | Secret values | `{}` |

## Example Values File

Create a file named `my-values.yaml`:

```yaml
antpolis:
  type: "nodejs-app"
  deploymentType: "helm"
  layer: "application"

app:
  url: "myapp.example.com"
  environment: "production"
  port: 3000

docker:
  repo: "mycompany/myapp"
  tag: "1.0.0"
  imagePullSecrets:
    - name: dockerhub

ingress:
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-issuer"
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
  domains:
    - name: "myapp.example.com"
      paths:
        path: "/"
        pathType: "Prefix"
        service:
          name: "myapp-service"
          port: 3000

persistence:
  enabled: true
  volumes:
    data:
      enabled: true
      size: 10Gi
      storageClass: "standard"
      mountPath: "/app/data"
      claim:
        enabled: true
        size: 10Gi
        storageClass: "standard"

configMap:
  enabled: true
  value:
    files:
      config.json:
        name: "config.json"
        content: |
          {
            "apiVersion": "v1",
            "environment": "production"
          }
        mountPath: "/app/config.json"
        subPath: "config.json"
    env:
      NODE_ENV: "production"
      API_VERSION: "v1"

secrets:
  enabled: true
  value:
    API_KEY: "your-api-key"
    DB_PASSWORD: "your-db-password"
```

## Usage

1. Create your custom values file based on the example above.
2. Install the chart:
```bash
helm install my-release . -f my-values.yaml
```

3. Verify the deployment:
```bash
kubectl get all -l "app.kubernetes.io/instance=my-release"
```

## Upgrading

To upgrade the release:
```bash
# Upgrade directly from GitHub
helm upgrade my-release git+https://github.com/Antpolis/app-chart.git -f my-values.yaml

# Or if you've cloned the repository:
helm upgrade my-release . -f my-values.yaml
```

## Uninstalling

To uninstall/delete the deployment:
```bash
helm uninstall my-release
```

## Support

For support, please create an issue in the repository.