base:
  '*':
    - global.software
    - global.ntp
    - global.users
    - global.ulimit
    - global.ssh
  'role:cosmos':
    - match: grain
    - openvpn
    - consul.server
