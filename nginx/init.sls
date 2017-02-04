nginx:
  pkgrepo.managed:
    - ppa: nginx/stable
  pkg.installed:
    - name: nginx
    - require:
      - pkgrepo: nginx
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: /etc/nginx/certs/wild-zerofox.com.crt
      - file: /etc/nginx/certs/wild-zerofox.com-no-pass.pem
      - file: /etc/nginx/nginx.conf

{% for filename in ('default', 'example_ssl') %}
/etc/nginx/conf.d/{{ filename }}.conf:
  file.absent:
    - require_in:
      - file: /etc/nginx/nginx.conf

/etc/nginx/sites-enabled/{{ filename }}:
  file.absent:
    - require_in:
      - file: /etc/nginx/nginx.conf
{% endfor %}

/etc/logrotate.d/nginx:
  file.managed:
    - source: salt://nginx/templates/logrotate.conf
    - user: root
    - group: root
    - mode: 0644

/etc/nginx:
  file.directory:
    - user: root
    - group: root

{% for dir in ['sites-available', 'sites-enabled'] -%}
/etc/nginx/{{ dir }}:
  file.directory:
    - user: www-data
    - group: www-data
    - mode: 0755
    - require:
      - file: /etc/nginx
{% endfor -%}

/etc/ssl/certs/dhparam.pem:
  file.managed:
    - user: www-data
    - group: www-data
    - makedirs: True
    - dir_mode: 755
    - file_mode: 400
    - contents_pillar: nginx_ssl:dhparam

/etc/nginx/nginx.conf:
  file.managed:
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://nginx/templates/config.jinja
    - require:
      - file: /etc/nginx

/etc/nginx/robots.txt:
  file.managed:
    - source: salt://nginx/templates/robots.txt
    - user: www-data
    - group: www-data
    - mode: 644
    - require:
      - file: /etc/nginx
