#
# Cookbook Name:: pptpd
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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
# 

package "pptpd" do
  action :install
end
execute "adding kernel modules" do
	command "modprobe ppp_mppe"
end


template "/etc/ppp/peers/pptpserver" do
  source "pptpserver.erb"
  owner "root"
  group "root"
  mode "0664"
end
pppd call pptpserver

execute "calling pptpserver" do
	command "pppd call pptpserver"
end

execute "adding route to pptpserver" do
	command "ip route add 192.168.240.0/8 dev ppp0"
end
