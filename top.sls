base:
  '*':
    - global.software                         #git, htop, iotop
    - global.grains-deps                      #python-pip, boto
  'not G@docker:true':
    - global.users
    - global.sysctl
    - global.ulimit
    - vault
  'docker:true':
    - match: grain
    - docker-helpers
  'ec2:True':
    - match: grain
    - global.security-updates                  #unattended upgrades
    - global.hosts                             #/etc/hosts
    - global.logrotate                         #/etc/logrotate.d/rsyslog
    - global.resolvconf
    - global.dnsmasq
    - global.newrelic-server
    - global.rsyslog
    - global.aws-cli
    - global.ntp
  'beats:true':
    - match: grain
    - beats
  'service:salt-master':
    - match: grain
    - salt-master
  'project_type:django':
    - match: grain
    - proj.django
  'project_type:celery':
    - match: grain
    - proj.celery
  'project_type:celery-beat':
    - match: grain
    - proj.celery-beat
  'project_type:node-standalone':
    - match: grain
    - proj.node-standalone
  'project_type:go':
    - match: grain
    - proj.go
  'project_type:go-web':
    - match: grain
    - proj.go-web
  'project_type:python-standalone':
    - match: grain
    - proj.python-standalone
  'project_type:celery-standalone':
    - match: grain
    - proj.celery-standalone
  'project_type:gulp-static-web':
    - match: grain
    - proj.gulp-static-web
  'service:consul-server':
    - match: grain
    - consul.server
  'service:vault':
    - match: grain
    - vault.server
  'not G@service:consul-server and not G@consul:false and not G@docker:true':
    - match: compound
    - consul.client
  'project_type:ipsec':
    - match: grain
    - proj.ipsec
  'service:mattermost':
    - match: grain
    - mattermost
  'service:rubycorp':
    - match: grain
    - rubycorp
  'service:elasticsearch':
    - match: grain
    - elasticsearch
  'service:logstash':
    - match: grain
    - logstash
  'service:kibana':
    - match: grain
    - kibana
