# envoy-gateway

Helm chart to install Envoy Gateway networking components with JayeX

## Prerequisites

This chart assumes you have already installed the Envoy Gateway controller using the official `envoyproxy/gateway-helm` chart.

Follow the instructions in the [official documentation](https://gateway.envoyproxy.io/latest/install/install-helm/), or install the chart directly from `versionStream` (`jx3 >= v1.1.0`).

## Introduction

**Envoy Gateway** is a Kubernetes-native Gateway API controller built on top of the Envoy Proxy, providing a powerful and flexible way to manage ingress traffic in Kubernetes environments.

However, the official Envoy Gateway Helm chart (`envoyproxy/gateway-helm`) only installs the controller — it does not ship with a `GatewayClass` or with the namespaced `EnvoyProxy` and `Gateway` resources (this is by design).

This chart fills that gap to support Gateway API-based ingress out-of-the-box in JayeX environments.

## Components

When installed, this chart deploys:

- A cluster-scoped `GatewayClass` that points at the Envoy Gateway controller (cluster-wide, optional on subsequent installs).
- A namespaced `EnvoyProxy` that configures the cloud Service (LoadBalancer / NodePort / cloud-specific annotations).
- A namespaced `Gateway` with HTTP and HTTPS listeners.
- An optional `HTTPRoute` that 301-redirects HTTP traffic to HTTPS.

## Installation

If you are using [JayeX](https://jayex.io/v3/about/), then add the following to your `helmfile.yaml`:

```yaml
repositories:
- name: jxgh
  url: https://jenkins-x-charts.github.io/repo
- name: envoyproxy
  url: docker.io/envoyproxy
  oci: true
releases:
- chart: envoyproxy/gateway-helm
  version: 1.7.2
  name: gateway-helm
  namespace: envoy-gateway-system
- chart: jxgh/envoy-gateway
  version: 0.0.1
  name: envoy-gateway
  namespace: envoy-gateway-system
```

Or install the charts directly with `helm`:

```bash
helm repo add envoyproxy https://docker.io/envoyproxy/charts
helm repo add jxgh https://jenkins-x-charts.github.io/repo
```

you can then do

```bash
helm search repo gateway-helm
helm search repo envoy-gateway
```

The charts install resources in the `envoy-gateway-system` namespace by default.

You can also install the `envoy-gateway` chart in additional namespaces (e.g. for multi-tenancy) — set `envoyGateway.gatewayClass.create=false` to avoid creating the cluster-scoped `GatewayClass` multiple times.
