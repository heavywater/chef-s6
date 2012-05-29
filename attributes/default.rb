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

default.s6.base_url = "http://www.skarnet.org/software"

default.s6.packages = Array.new

default.s6.packages << { "skalibs" =>
  { "type" => "prog", "version" => "1.2.7" }
}

default.s6.packages << { "execline" =>
  { "type" => "admin", "version" => "1.1.4" }
}

default.s6.packages << { "s6" =>
  { "type" => "admin", "version" => "0.16" }
}

case platform
when "ubuntu","debian"
  default.s6.log_dir = "/var/log/s6"
  default.s6.service_dir = "/service"
end
