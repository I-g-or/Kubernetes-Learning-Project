{{- define "ingress.labels" -}}
app.kubernetes.io/name: {{ .Values.name }}
app.kubernetes.io/component: ingress
app.kubernetes.io/part-of: todo-app
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}