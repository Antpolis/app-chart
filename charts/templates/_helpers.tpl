{{/*
Expand the name of the chart.
*/}}
{{- define "antpolis-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "antpolis-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "antpolis-app.labels" -}}
antpolis.app.name: {{ include "antpolis-app.name" . }}
antpolis.app.type: {{ .Values.antpolis.type | default "wordpress" }}
antpolis.app.url: {{ .Values.app.url }}
antpolis.app.environment: {{ .Values.app.environment }}
antpolis.app.deploymentType: {{ .Values.antpolis.deploymentType | default "helm" }}
antpolis.app.layer: {{ .Values.antpolis.layer | default "application" }}
antpolis.helm.release: {{ .Release.Name }}
helm.sh/chart: {{ include "antpolis-app.chart" . }}
app.kubernetes.io/version: {{ .Values.docker.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "antpolis-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "antpolis-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}