htop:
  pkg.latest

/root/.config/htop/htoprc:
    file.managed:
      - user: root
      - group: root
      - makedirs: True
      - file_mode: 644
      - dir_mode: 755
      - recurse:
        - user
        - group
        - mode
      - source: salt://global/htop/htoprc
