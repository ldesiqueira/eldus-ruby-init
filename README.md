# poise-ruby-init
LSB Init with the Daemons library in a cookbook

This cookbook is a quick way to wrap a script up and daemonize it in an init compliant way using ruby.
A virtual ruby is installed in /opt/ruby_builds/ and the daemons library is installed against it.
The init script is then wrapped and the following are true.

TODO:: Logs, log stuff isn't done yet

- pidfile is at /var/run/{name}.pid
- responds to chef service resource by name such that the following is valid
```
service #{name} do
  action :start
end
```
- start, stop, restart, status is provided automatically

- currently, further custimization of defaults is only available through replacing new_resource.template_stub.

Basic Usage
============
```
init_service #{service.name} do
  command #{command.string}
end
init_service #{service.name} do
  command #{command.string}
  command_args #{command.args}
end
```
```
service #{service.name} do
  action :start
end
service #{service.name} do
  action :stop
end
service #{service.name} do
  action :restart
end
```

Default Recipe
==============
- The default recipe will install runit and create an init daemon to start runsvdir on /service
