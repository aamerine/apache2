def mod_pagespeed_downloaded?(path, new_resource) #borrowed this function pattern from the java cookbook ark provider
  if ::File.exists? path
    require 'digest'
    sha = Digest::SHA256.file(path).hexdigest
    sha == new_resource.sha
  else
    return false
  end
end

def download_mod_pagespeed(new_resource)
  url = "#{new_resource.download_base_url}/#{new_resource.package_name}"
  p = package "curl" do
    action :nothing
  end
  p.run_action(:install)
  Chef::Log.debug "downloading the pagespeed package at #{url}"
  cmd = Chef::ShellOut.new(%Q[ curl -L #{url} -o #{Chef::Config[:file_cache_path]}/#{new_resource.package_name}])
  cmd.run_command
  cmd.error!
end

action :install do
  path_to_file = "#{Chef::Config[:file_cache_path]}/#{new_resource.package_name}"
  if mod_pagespeed_downloaded?(path_to_file, new_resource)
    Chef::Log.debug("mod_pagespeed already downloaded")
  else
    download_mod_pagespeed(new_resource)
  end
  execute "install mod_pagespeed" do
    command "dpkg -i #{Chef::Config[:file_cache_path]}/#{new_resource.package_name}"
  end
end