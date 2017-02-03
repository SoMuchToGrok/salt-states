include:
  - global.htop

iotop:
  pkg.latest

git:
  pkgrepo.managed:
    - ppa: git-core/ppa
    - keyserver: keyserver.ubuntu.com
    - keyid: E1DF1F24
    - humanname: git-ppa-trusty
    - name: deb http://ppa.launchpad.net/git-core/ppa/ubuntu xenial main
    - file: /etc/apt/sources.list.d/git-trusty.list
  pkg.latest:
    - name: git
    - require:
      - pkgrepo: git
