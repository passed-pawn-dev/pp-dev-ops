1. Create 'chart-secrets.yaml' that fills blank values from 'values.yaml'

e.g.

values.yaml:
keycloak:
  image: quay.io/keycloak/keycloak:26.0.5
  replicaCount: 1
  adminUsername: ""
  adminPassword: ""

secrets.yaml:
keycloak:
  adminUsername: "example-admin-username"
  adminPassword: "example-admin-password"

2. from ./pp-chart run: ```helm install pp-release . -f values.local.yaml -f chart-secrets.yaml```

the chart-secrets.yaml values override values.yaml values thus filling the secrets