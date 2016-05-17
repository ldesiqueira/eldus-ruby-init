init_service 'example' do
  command 'sleep 10'
end
service 'example' do
  action :start
end
