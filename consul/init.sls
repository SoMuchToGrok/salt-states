consul:
  archive.extracted:
    - name: /usr/bin/
    - source: https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_linux_amd64.zip
    - source_hash: https://releases.hashicorp.com/consul/0.7.3/consul_0.7.3_SHA256SUMS
    - source_hash_update: True
    - enforce_toplevel: False
    - archive_format: zip
    - extract_perms: False
    - overwrite: True
    - if_missing: /usr/bin/consul
  user.present:
    - home: /var/lib/consul
    - shell: /bin/false

/usr/bin/consul:
  file.managed:
    - mode: 750
    - user: root
    - group: consul
    - replace: False
    - require:
      - archive: consul
      - user: consul

/etc/systemd/system/consul.service:
  file.managed:
    - source: salt://consul/consul.service
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /usr/bin/consul

/var/log/consul:
  file.directory:
    - user: consul
    - group: consul
    - require:
      - user: consul
    - require_in:
      - file: /etc/systemd/system/consul.service

/etc/consul.d:
  file.directory:
    - user: root
    - group: consul
    - mode: 750
    - require_in:
      - file: /etc/systemd/system/consul.service
    - require:
      - user: consul

/etc/consul.d/base.json:
  file.managed:
    - source: salt://consul/base.json
    - template: jinja
    - user: root
    - group: root
    - require:
      - file: /etc/consul.d
