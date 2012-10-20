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
	if not options.misc: raise Exception("Gitty Error: The pull from command requires a remote and a branch.")
	#command="%s %s %s refs/heads/%s:refs/heads/%s"%(options.git,"pull",remote,branch,branch)
	remote=sanitize_str(options.misc[0])
	branch=sanitize_str(options.misc[1])
	command="%s %s %s"%(sanitize_str(options.git),"fetch",remote)
	rcode,stout,sterr=run_command(command)
	if server_hung_up(sterr):exit(85)
	if server_unreachable(sterr):exit(86)
	rcode_for_git_exit(rcode,sterr)
	command="%s %s %s"%(sanitize_str(options.git),"merge",remote+"/"+branch)
	rcode,stout,sterr=run_command(command)
	if server_hung_up(sterr):exit(85)
	if server_unreachable(sterr):exit(86)
	if check_for_git_error(sterr):exit(93)
	rcode_for_git_exit(rcode,sterr)
	exit(0)
except Exception, e:
	if stout.find("does not point to a commit") > -1: exit(89)
	sys.stderr.write("\ncommand: %s\n" % command)
	sys.stderr.write("The pull from command threw this error: " + str(e))
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)