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

package "pptp-linux" do
  action :install
end
package "network-manager-pptp" do
  action :install
end
execute "adding kernel modules" do
	command "modprobe ppp_mppe"
end

template "/etc/ppp/chap-secrets" do
  source "chap-secrets.erb"
  not_if "grep ^#{node[:pptpd][:username1]}\ pptpd /etc/ppp/chap-secrets"
  owner "root"
  group "root"
  mode "0600"
end
template "/etc/ppp/ip-up.d/route-traffic" do
  source "route-traffic.erb"
  owner "root"
  group "root"
  mode "0664"
end
execute "making executible" do
  command "chmod +x /etc/ppp/ip-up.d/route-traffic"
end

template "/etc/ppp/peers/pptpserver1" do
  source "pptpserver1.erb"
  owner "root"
  group "root"
  mode "0664"
end
template "/etc/ppp/pptpd-options" do
  not_if "grep ^ms-dns\  /etc/ppp/pptpd-options"
  source "pptpd-options.erb"
  variables :first_dns => node[:pptpd][:first_dns], :second_dns => node[:pptpd][:second_dns]
  owner "root"
  group "root"
  mode "0600"
end

template "/etc/ppp/options.pptp" do
  source "options.pptp.erb"
  owner "root"
  group "root"
  mode "0600"
end

execute "connecting server" do
  command "pppd call pptpserver1"
end

