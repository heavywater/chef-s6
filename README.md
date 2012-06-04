Description
===========

A runit_service compatible implementation for s6 supervision trees including logging.

See https://github.com/heavywater/chef-s6/blob/master/recipes/examples.rb for an example

Changes
=======

## v0.0.1

Roadmap
-------

* Publish Heavy Water public signed APT repository with S6 packages, consume those in a "package" recipe
* Pennyworth-built package integration

Requirements
============

## Platform:
* Debian/Ubuntu

Recipes
=======

default
-------

Installs and sets up s6 on the system, builds from source, statically compiles slashpackage convention style to the root of the filesystem.

Definitions
===========

The definition in this cookbook will be deprecated by an LWRP in a
future version. See __Roadmap__.

s6\_service
-----------
### Parameters:

* `name` - Name of the service. This will be used in the template file
  names (see __Usage__), as well as the name of the service resource
  created in the definition.
* `directory` - the directory where the service's configuration and
  scripts should be located. Default is `node['s6']['service_dir']`.
* `only_if` - unused, will be removed in a future version (won't be
  present in lwrp). Default is false.
* `finish_script` - if true, a finish script should be created.
  Default is false.
* `active_directory` - used for user-specific services. Default is
  `node['s6']['service_dir']`.
* `owner` - userid of the owner for the service's files, and should be
  used in the run template with chpst to ensure the service runs as
  that user. Default is root.
* `group` - groupid of the group for the service's files, and should
  be used in the run template with chpst to ensure the service runs as
  that group. Default is root.
* `template_name` - specify an alternate name for the templates
  instead of basing them on the name parameter. Default is the name parameter.
* `options` - a Hash of variables to pass into the run and log/run
  templates with the template resource `variables` parameter.
  Available inside the template(s) as `@options`. Default is an empty Hash.

### Examples:

Create templates for `sv-myservice-run.erb` and
`sv-myservice-log-run.erb` that have the commands for starting
myservice and its logger.

    s6_service "myservice"

License and Author
==================

Author:: AJ Christensen <aj@junglist.gen.nz>
Author:: Adam Jacob <adam@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>

Copyright:: 2012, AJ Christensen <aj@junglist.gen.nz>
Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
