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

# Mirrors the "runit_service" definition from Opscode
# Missing the start/stop/status/restart /etc/init.d/ symlink to 'sv'
# stuff that Runit does, not sure there is any benefit to including
# it.

# netcat listening on tcp/1234
s6_service "nc" do
  options :log_dir => "/var/log/nc"
end
