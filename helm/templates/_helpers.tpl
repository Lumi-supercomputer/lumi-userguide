{{/*
Expand the name of the chart.
*/}}
{{- define "lumi-docs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lumi-docs.builderName" -}}
{{- include "lumi-docs.name" . | printf "%s-builder" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "lumi-docs.webhookSecretName" -}}
{{- include "lumi-docs.name" . | printf "%s-webhook-secret" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "lumi-docs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "lumi-docs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "lumi-docs.labels" -}}
helm.sh/chart: {{ include "lumi-docs.chart" . }}
{{ include "lumi-docs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "lumi-docs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "lumi-docs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
