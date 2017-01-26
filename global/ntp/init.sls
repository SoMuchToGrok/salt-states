ntp:
  pkg.installed

ntpdate:
  pkg.installed

/etc/ntp.conf:
  file.managed:
  - name: /etc/ntp.conf
  - template: jinja
  - source: salt://global/ntp/ntp.conf
  - require:
    - pkg: ntp

ntp_running:
  service.running:
    - name: ntp
    - enable: True
    - watch:
      - file: /etc/ntp.conf
