{{/* Chart name, optionally overridden via .Values.nameOverride */}}
{{- define "envoy-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Fully-qualified release name, optionally overridden via .Values.fullnameOverride */}}
{{- define "envoy-gateway.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "envoy-gateway.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Chart label value (chart name + version) */}}
{{- define "envoy-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Standard labels stamped on every resource */}}
{{- define "envoy-gateway.labels" -}}
helm.sh/chart: {{ include "envoy-gateway.chart" . }}
{{ include "envoy-gateway.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: jayex
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/* Selector labels (subset of full labels, immutable on workloads) */}}
{{- define "envoy-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "envoy-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
