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
	if not options.misc: raise Exception("Gitty Error: The new tracking branch command requires the remote and branch to track.")
	branch=sanitize_str(options.misc[0])
	remoteBranch=sanitize_str(options.misc[1])
	remote=sanitize_str(options.misc[2])
	command="%s %s --track %s %s/%s"%(options.git,"branch",branch,remote,remoteBranch)
	rcode,stout,sterr=run_command(command)
	if not already_exists(sterr) and rcode > 1: raise Exception("Git exit status: "+str(rcode)+"\nGit stderr: %s" % str(sterr))
	if not already_exists(sterr):
		os.system("%s config --unset gity.default.remote.branch.%s" % (options.git,branch))
		os.system("%s config --add gity.default.remote.branch.%s %s" % (options.git,branch,remote))
	exit(0)
except Exception, e:
	sys.stderr.write("The new tracking branch command threw this error: " + str(e))
	sys.stderr.write("\ncommand: %s\n" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)