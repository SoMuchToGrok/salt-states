net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

ufw:
  pkg.installed:
    - name: ufw
  service.running:
    - enable: True
    - watch:
      - file: /etc/default/ufw
      - file: /etc/ufw/before.rules
  cmd.run:
    - name: |
        ufw allow OpenSSH
        ufw allow 1194/udp
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
      - cmd: /etc/openvpn/dh.pem
      - cmd: /etc/openvpn/ta.key

/etc/openvpn/server.conf:
  file.managed:
    - source: salt://openvpn/server.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openvpn

/var/log/openvpn:
  file.directory:
    - user: root
    - group: root
    - require_in:
      - file: /etc/openvpn/server.conf

/etc/logrotate.d/openvpn:
  file.managed:
    - source: salt://openvpn/logrotate.conf
    - user: root
    - group: root
    - mode: 644

/etc/openvpn/dh.pem:
  cmd.run:
    - name: ./easyrsa gen-dh && mv pki/dh.pem /etc/openvpn/dh.pem
    - cwd: /root/easy-rsa/easyrsa3
    - unless: ls /etc/openvpn/dh.pem

/etc/openvpn/ta.key:
  cmd.run:
    - name: openvpn --genkey --secret /etc/openvpn/ta.key
    - unless: ls /etc/openvpn/ta.key
    - require:
      - pkg: openvpn

/etc/default/ufw:
  file.managed:
    - source: salt://openvpn/ufw_default
    - user: root
    - group: root
    - mode: 644

/etc/ufw/before.rules:
  file.managed:
    - source: salt://openvpn/ufw_before_rules
    - user: root
    - group: root
    - mode: 644

/root/client-configs/files:
  file.directory:
    - user: root
    - group: root
    - mode: 700

/root/client-configs/base.conf:
  file.managed:
    - source: salt://openvpn/base.conf
    - user: root
    - group: root
    - mode: 700

/root/client-configs/make_config.sh:
  file.managed:
    - source: salt://openvpn/make_config.sh
    - user: root
    - group: root
    - mode: 700
