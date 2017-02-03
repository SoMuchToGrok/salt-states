net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

ufw:
  pkg.installed:
    - name: ufw
  service.running:
    - enable: True
  cmd.run:
    - name: |
        ufw allow OpenSSH
        sudo ufw --force enable
    - runas: root

easy-rsa:
  git.latest:
    - name: https://github.com/OpenVPN/easy-rsa.git
    - target: /root/easy-rsa
    - user: root

openvpn:
  cmd.run:
    - name: wget -O - https://swupdate.openvpn.net/repos/repo-public.gpg|apt-key add -
    - runas: root
  pkgrepo.managed:
    - keyserver: keyserver.ubuntu.com
    - keyid: E158C569
    - humanname: openvpn-apt-repo
    - name: deb http://build.openvpn.net/debian/openvpn/stable xenial main
    - file: /etc/apt/sources.list.d/openvpn-xenial.list
    - clean_file: true
    - watch:
      - cmd: openvpn
  pkg.latest:
    - require:
      - pkgrepo: openvpn
  service.running:
    - enable: True
    - watch:
      - pkg: openvpn
      - file: /etc/openvpn/server.conf

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/server.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/logrotate.d/openvpn:
  file.managed:
    - source: salt://openvpn/logrotate.conf
    - user: root
    - group: root
    - mode: 644
