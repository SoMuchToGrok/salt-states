/etc/security/limits.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://global/ulimit/limits.conf.jinja

/etc/pam.d/common-session:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://global/ulimit/common-session

/etc/pam.d/common-session-noninteractive:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://global/ulimit/common-session-noninteractive
