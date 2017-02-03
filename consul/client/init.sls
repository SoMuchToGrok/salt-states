include:
  - consul

/etc/consul.d/client.json:
  file.managed:
    - source: salt://consul/client/client.json
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/consul.d
    - watch_in:
      - service: consul
