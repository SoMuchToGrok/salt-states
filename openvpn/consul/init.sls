include:
  - consul

/etc/consul.d/openvpn_service.json:
  file.managed:
    - source: salt://openvpn/consul/service.json.jinja
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/consul.d
      - file: /bin/check_openvpn
      - file: /etc/sudoers.d/openvpn-consul
    - watch_in:
      - service: consul

/etc/sudoers.d/openvpn-consul:
  file.managed:
    - source: salt://openvpn/consul/consul.sudoers
    - user: root
    - group: root
    - mode: 440
    - require:
      - user: consul

/bin/check_openvpn:
  file.managed:
    - source: salt://openvpn/consul/check_openvpn.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 755
