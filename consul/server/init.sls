include:
  - consul

/etc/consul.d/server.json:
  file.managed:
    - source: salt://consul/server/server.json
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/consul.d
    - watch_in:
      - service: consul

/etc/consul.d/ui.json:
  file.managed:
    - source: salt://consul/server/ui.json
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/consul.d
    - watch_in:
      - service: consul
