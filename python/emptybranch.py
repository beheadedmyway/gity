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
	import sys,re,os,subprocess
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
command=""
try:
	from _argv import *
	if not options.misc: raise Exception("Gitty Error: The new empty branch command requires a branch.")
	command="%s %s"%(options.git,"symbolic-ref HEAD refs/heads/%s"%sanitize_str(str(options.misc[0])))
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	os.system("rm -rf .git/index") #remove index
	os.system("%s clean -fdx"%options.git) #clean
	#setup the must haves for a new empty branch (this forces the new branch to be created)
	#otherwise the new branch is in limbo, with HEAD being a non ref
	os.system("touch .gitignore")
	os.system("%s add ."%options.git)
	os.system("%s commit -m 'Initial Commit For New Branch'"%options.git)
	exit(0)
except Exception, e:
	sys.stderr.write("The empty branch command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	exit(84)