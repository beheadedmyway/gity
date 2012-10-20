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
command=""
try:
	from _argv import *
	if not options.misc: raise Exception("Gitty Error: The set default remote command requires a branch and remote.")
	remote = sanitize_str(options.misc[0])
	branch = sanitize_str(options.misc[1])
	glog("command: %s config --unset gity.default.remote.branch.%s %s"%(options.git,branch,remote))
	glog("command: %s config --add gity.default.remote.branch.%s %s"%(options.git,branch,remote))
	os.system("%s config --unset gity.default.remote.branch.%s %s"%(options.git,branch,remote))
	os.system("%s config --add gity.default.remote.branch.%s %s"%(options.git,branch,remote))
	exit(0)
except Exception, e:
	sys.stderr.write("The set default remote command threw this error: " + str(e))
	sys.stderr.write("\ncommand: %s\n" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)