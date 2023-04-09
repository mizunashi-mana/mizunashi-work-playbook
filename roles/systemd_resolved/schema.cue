package systemd_resolved

systemd_resolved_public_dns: string
systemd_resolved_internal_dns: string
systemd_resolved_fallback_dns: [...string]|*["4.2.2.1", "4.2.2.2"]
systemd_resolved_stub_listener: bool | *true
