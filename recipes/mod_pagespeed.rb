case node['platform_family']
when "debian"
	apache2_mod_pagespeed "install_mod_pagespeed" do
		package_name node['apache']['mod_pagespeed']['package_name']
		sha node['apache']['mod_pagespeed']['digest']
		download_base_url node['apache']['mod_pagespeed']['download_base_url']
		action :install
	end
end

apache_module "pagespeed"