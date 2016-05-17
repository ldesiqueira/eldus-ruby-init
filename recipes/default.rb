runit_install 'this'
directory '/service' do
  mode 0777
end
file '/bin/runsvdir-start' do
  content <<-EOH
#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin
exec env - PATH=$PATH \
runsvdir -P /service 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'
  EOH
  mode 0777
end
init_service 'runit' do
  command '/bin/runsvdir-start'
end
