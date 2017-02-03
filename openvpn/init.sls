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
