runit_install 'this'
directory '/services' do
  mode 0777
end
file '/bin/runsvdir-start' do
  content <<-EOH
#!/bin/sh
PATH=/usr/local/bin:/usr/local/sbin:/bin:/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin
exec env - PATH=$PATH \
runsvdir -P /services 'log: ...........................................................................................................................................................................................................................................................................................................................................................................................................'
  EOH
  mode 0777
end
init_service 'runit' do
  command '/bin/runsvdir-start'
  mode 0777
  chkconfig true
end
