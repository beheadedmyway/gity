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
	if not options.misc: raise Exception("Gitty Error: The delete branch command requires a branch.")
	branch=sanitize_str(options.misc[0])
	command="%s %s %s"%(options.git,"branch -D",branch)
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	try:
		if options.misc[1]:
			command="%s %s" % (options.git,"remote show")
			rcode,stout,sterr=run_command(command)
			rcode_for_git_exit(rcode,sterr)
			lines=re.split("\n",stout)
			lines.pop()
			for line in lines:
				try:
					remote=sanitize_str(line)
					command="%s %s %s :refs/heads/%s" %(options.git,"push",remote,branch)
					run_free_command(command)
				except: continue
	except:
		pass
	try:
		while(os.wait()): pass
	except: pass
	try:
		unset_gity_default_remote_for_branch(options.git,branch)
	except: pass
	exit(0)
except Exception, e:
	sys.stderr.write("The delete branch command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)