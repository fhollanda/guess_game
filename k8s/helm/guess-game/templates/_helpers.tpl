{{/*
Nome base do chart
*/}}
{{- define "guess-game.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Nome completo do release
*/}}
{{- define "guess-game.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Labels comuns aplicados a todos os recursos
*/}}
{{- define "guess-game.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels do backend
*/}}
{{- define "guess-game.backend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "guess-game.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels do frontend
*/}}
{{- define "guess-game.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "guess-game.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels do postgres
*/}}
{{- define "guess-game.postgres.selectorLabels" -}}
app.kubernetes.io/name: {{ include "guess-game.name" . }}-postgres
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
