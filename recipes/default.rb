#
# Cookbook Name:: s6
# Recipe:: default
#
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

# We're compiling this for now.
# TODO: build with Pennyworth, publish public repository
include_recipe "build-essential"

# Some of the compilation steps require entropy
package "haveged" do
  not_if do
    File.directory? "/command"
  end
end

# s6 uses the DJB "slashpackage" convention.
# Make sure "prog" type slashpackages are installed first -- the
# others depend on them.
%w[prog admin].each do |package_type|
  node.s6.packages.select do |package|
    Chef::Log.info "s6: checking package: #{package.keys.first} for type: #{package_type}"
    package.values.first["type"] == package_type
  end.each do |package|
    pkg = package.keys.first
    options = package.values.first
    Chef::Log.info "s6: installing #{package.inspect}"
    package_dir = "/package"
    package_version = "#{pkg}-#{options['version']}"
    package_tarball = package_version + ".tar.gz"
    package_tarball_path = File.join(package_dir, package_tarball)

    url = URI.parse(node.s6.base_url)
    url.path = File.join(url.path, pkg, package_tarball)

    package_url = url.to_s

    directory package_dir do
      mode 01755
      recursive true
    end

    remote_file package_tarball_path do
      source package_url
      action :create_if_missing
    end

    execute "#{pkg}: unpack" do
      command "tar zxvf #{package_tarball}"
      cwd package_dir
      action :nothing
      subscribes( :run,
                  resources(:remote_file => package_tarball_path),
                  :immediately )
    end

    # Statically compile each of the libs. Seems a little arcane
    # compared to ./configure, but actually easier to automate.
    file File.join( package_dir,
                    options['type'],
                    package_version,
                    "conf-compile",
                    "flag-allstatic" ) do
      action :create_if_missing
    end

    execute "#{pkg}: compile and install" do
      command "make && make install"
      cwd File.join(package_dir, options['type'], package_version)
      creates File.join(package_dir, options['type'], pkg)
    end
  end
end

directory node.s6.log_dir do
  mode 01755
  owner "syslog"
  group "adm"
end

%w[s6-svscan-log].each do |service_directory|
  directory File.join("/service", service_directory) do
    mode 01755
    recursive true
  end
end

# This script launches s6-svscan and friends, sets up some pipes.
template "/command/s6-svscanboot" do
  mode 01755
end

# Yeah yeah, it's weird. Who cares.
file "/etc/profile.d/s6.sh" do
  content <<-EOH
export PATH=$PATH:/command
EOH
  mode 00644
end

case node['platform']
when "debian", "ubuntu"
  template "/etc/init/s6-svscan.conf" do
    mode 00644
  end

  service "s6-svscan" do
    provider Chef::Provider::Service::Upstart
    action [:enable, :start]
  end
end

