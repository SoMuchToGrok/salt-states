openvpn:
  pkgrepo.managed:
    - keyserver: keyserver.ubuntu.com
    - keyid: E158C569
    - humanname: openvpn-ppa-xenial
    - name: deb https://swupdate.openvpn.net/apt xenial main
    - file: /etc/apt/sources.list.d/openvpn-xenial.list
  pkg.installed:
    - require:
      - pkgrepo: openvpn
