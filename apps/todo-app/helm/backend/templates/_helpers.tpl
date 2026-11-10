{{- define "backend.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.backendName }}
app.kubernetes.io/component: api
{{- end }}

{{- define "backend.labels" -}}
{{ include "backend.selectorLabels" . }}
app.kubernetes.io/part-of: todo-app
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}