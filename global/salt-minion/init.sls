salt-minion:
  pkgrepo.managed:
    - name: deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub
  pkg.latest:
    - require:
      - pkgrepo: salt-minion
  service.running:
    - enable: True
    - require:
      - pkg: salt-minion
