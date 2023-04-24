package systemd_resolved

systemd_resolved_primary_dns: string
systemd_resolved_fallback_dns: [...string]
systemd_resolved_stub_listener: bool | *true
