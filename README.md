Steps
-------
1. Change directory into root of this repository
1. Change `root_dir`, `file_roots`, `pillar_roots` in `./master/etc/salt/master` to the correct paths on your machine
1. Change `root_dir` in `./minion/etc/salt/minion` to the correct paths on your machine
1. Run master `salt-master -c ./master/etc/salt/`
1. Run minion `salt-minion -c ./minion/etc/salt/`
1. Accept minion key on master `salt-key -c ./master/etc/salt/ -A`
1. Apply minion state: `salt-call -c ./minion/etc/salt/ state.apply`

Expected output
-------
```
$ cat ./minion/test_file
qa1db.example.com
```

Log output
-------
```
---
2017-01-25 15:13:35,306 [salt.pillar      ][CRITICAL][24815] Rendering SLS 'qa' failed, render error:
Jinja error: unsupported operand type(s) for +: 'NoneType' and 'str'
Traceback (most recent call last):
  File "/Users/tobi/salt/salt/utils/templates.py", line 355, in render_jinja_tmpl
    output = template.render(**decoded_context)
  File "/Users/tobi/salt/env/lib/python2.7/site-packages/jinja2/environment.py", line 1008, in render
    return self.environment.handle_exception(exc_info, True)
  File "/Users/tobi/salt/env/lib/python2.7/site-packages/jinja2/environment.py", line 780, in handle_exception
    reraise(exc_type, exc_value, tb)
  File "<template>", line 1, in top-level template code
TypeError: unsupported operand type(s) for +: 'NoneType' and 'str'

; line 1

---
test_pillar: {{ grains.get('role') + 'db.example.com' }}    <======================

Traceback (most recent call last):
  File "/Users/tobi/salt/salt/utils/templates.py", line 355, in render_jinja_tmpl
    output = template.render(**decoded_context)
  File "/Users/tobi/salt/env/lib/python2.7/site-packages/jinja2/environment.py", line 1008, in render
[...]
---
2017-01-25 15:13:35,307 [salt.pillar      ][CRITICAL][24815] Pillar render error: Rendering SLS 'qa' failed. Please see master log for details.
```

Observations
-------
Adding the following to `./master/etc/salt/master` silences the error, but then uses the grain of the master and not the minion:
```
grains:
  role: master
```
Leading to the, with my understanding, incorrect:
```
$ cat ./minion/test_file
masterdb.example.com
```
