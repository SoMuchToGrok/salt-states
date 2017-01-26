openvpn:
  pkgrepo.managed:
    - keyserver: keyserver.ubuntu.com
    - keyid: E158C569
    - humanname: openvpn-ppa-xenial
    - name: deb http://build.openvpn.net/debian/openvpn/release/2.4 xenial main
    - file: /etc/apt/sources.list.d/openvpn-xenial.list
  pkg.installed:
    - require:
      - pkgrepo: openvpn
