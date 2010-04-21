# Copyright Aaron Smith 2009
# 
# This file is part of Gity.
# 
# Gity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Gity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with Gity. If not, see <http://www.gnu.org/licenses/>.
from _util import *
try:
	import re,os,subprocess,simplejson as json
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
stout=""
sterr=""
command=""
try:
	from _argv import *
	command="%s %s" % (options.git,"config -f .git/config --list")
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	res=re.split("\n",stout)
	configs=[]
	if len(res) > 0:
		res.pop()
		for line in res:
			a=line.split("=")
			if not a: continue
			if not a[0]: continue
			configs.append([sanitize_str(a[0]),sanitize_str(a[1])])
	make_vendor_tmp_dir()
	configsfile=open(".git/vendor/gity/tmp/configs.json","w")
	configsfile.write(json.dumps(configs))
	configsfile.close()
	exit(0)
except Exception, e:
	sys.stderr.write("The configs command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)