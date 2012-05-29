#
# Cookbook Name:: s6
# Definition:: s6_service
#
# Copyright 2008-2009, Opscode, Inc.
# Copyright 2012, AJ Christensen <aj@junglist.gen.nz>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

define( :s6_service,

        :directory => nil,
        :only_if => false,
        :finish_script => false,
        :active_directory => nil,
        :owner => "root",
        :group => "root",
        :template_name => nil,
        :options => Hash.new ) do

  include_recipe "s6"

  params[:active_directory] ||= node[:s6][:service_dir]
  params[:template_name] ||= params[:name]

  service_dir_name = "#{params[:active_directory]}/#{params[:name]}"

  directory "#{service_dir_name}/log" do
    owner params[:owner]
    group params[:group]
    mode 0755
    action :create
    recursive true
  end

  template "#{service_dir_name}/run" do
    owner params[:owner]
    group params[:group]
    mode 0755
    source "sv-#{params[:template_name]}-run.erb"
    cookbook params[:cookbook] if params[:cookbook]
    if params[:options].respond_to?(:has_key?)
      variables :options => params[:options]
    end
  end

  template "#{service_dir_name}/log/run" do
    owner params[:owner]
    group params[:group]
    mode 0755
    source "sv-#{params[:template_name]}-log-run.erb"
    cookbook params[:cookbook] if params[:cookbook]
    if params[:options].respond_to?(:has_key?)
      variables :options => params[:options]
    end
  end

  if params[:finish_script]
    template "#{service_dir_name}/finish" do
      owner params[:owner]
      group params[:group]
      mode 0755
      source "sv-#{params[:template_name]}-finish.erb"
      cookbook params[:cookbook] if params[:cookbook]
      if params[:options].respond_to?(:has_key?)
        variables :options => params[:options]
      end
    end
  end

  execute "s6: scan for services and reap old processes" do
    command "/command/s6-svscanctl -az #{params[:active_directory]}"
  end

  ruby_block "supervise_#{params[:name]}_sleep" do
    block do
      Chef::Log.debug("Waiting until named pipe #{service_dir_name}/supervise/control exists.")
      (1..10).each {|i| sleep 1 unless ::FileTest.pipe?("#{service_dir_name}/supervise/control") }
    end
    not_if { FileTest.pipe?("#{service_dir_name}/supervise/control") }
  end

end
