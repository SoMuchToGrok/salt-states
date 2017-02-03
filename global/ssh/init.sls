/etc/ssh/sshd_config:
  file.managed:
    - source: salt://global/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 644
