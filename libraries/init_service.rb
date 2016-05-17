require 'poise'
require 'chef/resource'
require 'chef/provider'

module InitService
  class Resource < Chef::Resource
    include Poise
    provides  :init_service
    actions   :install
    attribute :name, name_attribute: true
    attribute :command
    attribute :command_args, default: ''
    attribute :path, default: '/etc/init.d/'
    attribute :chkconfig, default: true
    attribute :options, default: {}
    attribute :ruby_version, default: '2.1.2'
    attribute :mode, default: 0777
    attribute :template_stub, default: 'service.erb'
    attribute :local_cookbook, default: 'poise-ruby-init'
    attribute :user, default: 'root'
    attribute :group, default: 'root'
    attribute :required_start, default: 'networking'
    attribute :required_stop, default: 'networking'
    attribute :default_start, default: '2 3 4 5'
    attribute :default_stop, default: '0 1 6'
  end
  class Provider < Chef::Provider
    include Poise
    provides :init_service
    def interpreter
      "/opt/ruby_build/builds/#{new_resource.name}/bin/ruby"
    end
    def env
      ruby_runtime new_resource.name do
        provider :ruby_build
        version new_resource.ruby_version
      end
      ruby_gem 'daemons'
    end
    def action_install
      env
      template "#{new_resource.path}#{new_resource.name}" do
        source new_resource.template_stub
        mode new_resource.mode
        user new_resource.user
        group new_resource.group
        variables :context => {
          :name => new_resource.name,
          :interpreter => self.interpreter,
          :required_start => new_resource.required_start,
          :required_stop => new_resource.required_stop,
          :default_start => new_resource.default_start,
          :default_stop => new_resource.default_stop,
          :short_description => "#{new_resource.name} Service",
          :long_description => "Managed by Chef",
          :command => new_resource.command,
          :command_args => new_resource.command_args
        }
        if new_resource.chkconfig
          bash "adding #{new_resource.name} to chkconfig" do
            code <<-EOH
            chkconfig --add #{new_resource.name}
            EOH
            not_if "chkconfig|grep #{new_resource.name}"
          end
        end
      end
    end
  end
end
