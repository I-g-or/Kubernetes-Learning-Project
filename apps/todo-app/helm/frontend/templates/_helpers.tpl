{{- define "frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.frontendName }}
app.kubernetes.io/component: ui
{{- end }}

{{- define "frontend.labels" -}}
{{ include "frontend.selectorLabels" . }}
app.kubernetes.io/part-of: todo-app
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
