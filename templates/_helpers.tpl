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
Merge ingress configuration
*/}}
{{- define "antpolis-app.mergeIngress" -}}
{{- $defaultIngress := .Values.ingress }}
{{- $userIngress := .Values.userIngress | default dict }}
{{- $result := deepCopy $defaultIngress }}
{{- if $userIngress }}
  {{- if $userIngress.className }}
    {{- $_ := set $result "className" $userIngress.className }}
  {{- end }}
  {{- if $userIngress.annotations }}
    {{- $_ := set $result "annotations" (merge $userIngress.annotations $defaultIngress.annotations) }}
  {{- end }}
  {{- if $userIngress.domains }}
    {{- $mergedDomains := concat $userIngress.domains $defaultIngress.domains }}
    {{- $_ := set $result "domains" $mergedDomains }}
  {{- end }}
{{- end }}
{{- toYaml $result }}
{{- end }}

{{/*
Merge configmap configuration
*/}}
{{- define "antpolis-app.mergeConfigMap" -}}
{{- $defaultConfig := .Values.configMap }}
{{- $userConfig := .Values.userConfigMap | default dict }}
{{- $mergedConfig := merge $userConfig $defaultConfig }}
{{- $result := deepCopy $mergedConfig }}
{{- if and $userConfig.wordpress $defaultConfig.wordpress }}
  {{- $mergedWordpress := merge $userConfig.wordpress $defaultConfig.wordpress }}
  {{- if and $userConfig.wordpress.files $defaultConfig.wordpress.files }}
    {{- $mergedFiles := merge $userConfig.wordpress.files $defaultConfig.wordpress.files }}
    {{- $_ := set $mergedWordpress "files" $mergedFiles }}
  {{- end }}
  {{- if and $userConfig.wordpress.env $defaultConfig.wordpress.env }}
    {{- $mergedEnv := merge $userConfig.wordpress.env $defaultConfig.wordpress.env }}
    {{- $_ := set $mergedWordpress "env" $mergedEnv }}
  {{- end }}
  {{- $_ := set $result "wordpress" $mergedWordpress }}
{{- end }}
{{- toYaml $result }}
{{- end }}

{{/*
Merge secrets configuration
*/}}
{{- define "antpolis-app.mergeSecrets" -}}
{{- $defaultSecrets := .Values.secrets }}
{{- $userSecrets := .Values.userSecrets | default dict }}
{{- $mergedSecrets := merge $userSecrets $defaultSecrets }}
{{- $result := deepCopy $mergedSecrets }}
{{- if and $userSecrets.wordpress $defaultSecrets.wordpress }}
  {{- $mergedWordpress := merge $userSecrets.wordpress $defaultSecrets.wordpress }}
  {{- $_ := set $result "wordpress" $mergedWordpress }}
{{- end }}
{{- toYaml $result }}
{{- end }}

{{/*
Merge persistence configuration
*/}}
{{- define "antpolis-app.mergePersistence" -}}
{{- $defaultPersistence := .Values.persistence }}
{{- $userPersistence := .Values.userPersistence | default dict }}
{{- $mergedPersistence := merge $userPersistence $defaultPersistence }}
{{- $result := deepCopy $mergedPersistence }}
{{- if and $userPersistence.volumes $defaultPersistence.volumes }}
  {{- $mergedVolumes := merge $userPersistence.volumes $defaultPersistence.volumes }}
  {{- $_ := set $result "volumes" $mergedVolumes }}
{{- end }}
{{- toYaml $result }}
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