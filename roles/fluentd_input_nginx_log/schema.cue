package fluentd_input_nginx_log

fluentd_input_nginx_log_error_tag: string

fluentd_input_nginx_log_access_entries: [string]: #FluentdInputNginxAccessLogEntry

#FluentdInputNginxAccessLogEntry: {
  log_file: string
}
