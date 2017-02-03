openvpn:
  pkgrepo.managed:
    - keyserver: keyserver.ubuntu.com
    - keyid: E158C569
    - humanname: openvpn-apt-repo
    - name: deb http://build.openvpn.net/debian/openvpn/stable xenial main
    - file: /etc/apt/sources.list.d/openvpn-xenial.list
    - clean_file: true
  pkg.installed:
    - require:
      - pkgrepo: openvpn
      - file: /etc/apt/trusted.gpg.d/openvpn.gpg

/etc/apt/trusted.gpg.d/openvpn.gpg:
  file.managed:
    - source: https://swupdate.openvpn.net/repos/repo-public.gpg
    - user: root
    - group: root
    - mode: 644
