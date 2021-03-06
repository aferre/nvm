#
# Cookbook Name:: nvm
# Provider:: nvm_install
#
# Copyright 2013, HipSnip Limited
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

action :create do
	from_source_message = new_resource.from_source ? ' from source' : ''
	from_source_arg = new_resource.from_source ? '-s' : ''
	bash "Installing node.js #{new_resource.version}#{from_source_message} as user #{node['nvm']['user']}..." do
		code <<-EOH
			#{node['nvm']['source']}
			nvm install #{from_source_arg} #{new_resource.version}
		EOH
		user node['nvm']['user']
	end
	# break FC021: Resource condition in provider may not behave as expected
	# silly thing because new_resource.version is dynamic not fixed
	nvm_alias_default new_resource.version do
		action :create
		only_if { new_resource.alias_as_default }
	end
	new_resource.updated_by_last_action(true)
end