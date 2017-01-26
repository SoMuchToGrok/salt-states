base:
  '*':
    - global.software
    - global.ntp
    - global.users
    - global.ulimit
  'role:cosmos':
    - match: grain
    - openvpn
