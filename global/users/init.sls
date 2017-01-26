include:
  - global.users.sudo

{% set env = salt['grains.get']('env', 'dev') %}
{% if env == 'prod' %}
{% set default_prod = salt['pillar.get']('default_prod') %}
{% set user_list = salt['pillar.get']('proj:prod_users', default_prod) %}
{% else %}
{% set user_list = salt['pillar.get']('users', {}) %}
{% endif %}
{% for name in user_list %}
{% set user = salt['pillar.get']('users:'+name, {}) %}
{% set home = user.get('home', "/home/%s" % name) %}

{% for group in user.get('groups', []) %}
{{ name }}_{{ group }}_group:
  group:
    - name: {{ group }}
    - present
{% endfor %}

{{ name }}_user:
  file.directory:
    - name: {{ home }}
    - user: {{ name }}
    - group: {{ name }}
    - mode: 0755
    - require:
      - user: {{ name }}
      - group: {{ name }}
  group.present:
    - name: {{ name }}
    {% if 'uid' in user -%}
    - gid: {{ user['uid'] }}
    {% endif %}
  user.present:
    - name: {{ name }}
    - home: {{ home }}
    - shell: {{ user.get('shell', '/bin/bash') }}
    {% if 'uid' in user -%}
    - uid: {{ user['uid'] }}
    {% endif %}
    - gid_from_name: True
    {% if 'fullname' in user %}
    - fullname: {{ user['fullname'] }}
    {% endif %}
    {% if 'hash' in user %}
    - password: {{ user['hash'] }}
    {% endif %}
    - system: {{ user.get('system', False) }}
    - groups:
        - {{ name }}
      {% for group in user.get('groups', []) %}
        - {{ group }}
      {% endfor %}
    - require:
        - group: {{ name }}
      {% for group in user.get('groups', []) %}
        - group: {{ name }}_{{ group }}_group
      {% endfor %}

{{ user.get('home', '/home/{0}'.format(name)) }}/.config/htop/htoprc:
    file.managed:
      - user: {{ name }}
      - group: {{ name }}
      - makedirs: True
      - file_mode: 644
      - dir_mode: 755
      - recurse:
        - user
        - group
        - mode
      - source: salt://global/htop/htoprc

user_keydir_{{ name }}:
  file.directory:
    - name: {{ user.get('home', '/home/{0}'.format(name)) }}/.ssh
    - user: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - mode: 700
    - require:
      - user: {{ name }}
      - group: {{ name }}
      {% for group in user.get('groups', []) %}
      - group: {{ name }}_{{ group }}_group
      {% endfor %}

  {% if 'privkey' in user %}
user_{{ name }}_private_key:
  file.managed:
    - name: {{ user.get('home', '/home/{0}'.format(name)) }}/.ssh/id_rsa
    - user: {{ name }}
    - group: {{ name }}
    - mode: 600
    {% if 'contents' in user['privkey'] %}
    - contents_pillar: 'users:{{ name }}:privkey:contents'
    {% else %}
    - source: salt://keys/{{ user['privkey'] }}
    {% endif %}
    - require:
      - user: {{ name }}_user
      {% for group in user.get('groups', []) %}
      - group: {{ name }}_{{ group }}_group
      {% endfor %}
  {% endif %}


  {% if 'ssh_auth' in user %}
  {% for auth in user['ssh_auth'] %}
ssh_auth_{{ name }}_{{ loop.index0 }}:
  ssh_auth.present:
    - user: {{ name }}
    - name: {{ auth }}
    - require:
        - file: {{ name }}_user
        - user: {{ name }}_user
{% endfor %}
{% endif %}

{% if 'dotfiles' in user %}
{{ user['dotfiles']['destination'] }}:
  file.directory:
    - user: {{ name }}
    - group: {{ name }}
    - makedirs: True
    - require:
      - user: {{ name }}_user
      {% for group in user.get('groups', []) %}
      - group: {{ name }}_{{ group }}_group
      {% endfor %}

{{ user['dotfiles']['repository'] }}_{{ name }}:
  git.latest:
    - name: {{ user['dotfiles']['repository'] }}
    - target: {{ user['dotfiles']['destination'] }}
    {% if 'rev' in user['dotfiles'] %}
    - rev: {{ user['dotfiles']['rev'] }}
    {% endif %}
    - user: {{ name }}
    - require:
      - file: {{ user['dotfiles']['destination'] }}

{{ user['dotfiles']['install_cmd'] }}_{{ name }}:
  cmd.wait:
    - name: {{ user['dotfiles']['install_cmd'] }}
    - user: {{ name }}
    - cwd: {{ user['dotfiles']['destination'] }}
    - watch:
      - git: {{ user['dotfiles']['repository'] }}_{{ name }}
{% endif %}

{% if 'sudouser' in user and user['sudouser'] %}
sudoer-{{ name }}:
  file.managed:
    - name: /etc/sudoers.d/{{ name }}
    - user: root
    - group: root
    - mode: '0440'
/etc/sudoers.d/{{ name }}:
  file.append:
  - text:
    - "{{ name }}    ALL=(ALL)  NOPASSWD: ALL"
  - require:
    - file: sudoer-defaults
    - file: sudoer-{{ name }}
{% else %}
/etc/sudoers.d/{{ name }}:
  file.absent:
    - name: /etc/sudoers.d/{{ name }}
{% endif %}

{% endfor %}

{% for user in pillar.get('absent_users', []) %}
{{ user }}:
  user.absent
/etc/sudoers.d/{{ user }}:
  file.absent:
    - name: /etc/sudoers.d/{{ user }}
{% endfor %}
