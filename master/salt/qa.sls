{{ salt['config.get']('root_dir') }}/test_file:
  file.managed:
    - contents:
      - {{ pillar['test_pillar'] }}
