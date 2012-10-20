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
	import sys,re,os,subprocess,time
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
from _argv import *
stout=""
sterr=""
command=""
def get_current_branch():
	global stout,sterr
	command="%s %s"%(options.git,"status")
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	if not_on_branch(stout):
		command="%s %s --pretty=format:%s"%(options.git,"show","%h")
		rcode,stout,sterr=run_command(command)
		pieces=stout.split("\n")
		abbrevhash=pieces[0]
		sys.stdout.write(abbrevhash)
		exit(79)
	try:
		res=re.search("On branch .*",stout)
		mat=sanitize_str(res.group(0))
		a=re.split(" ",mat)
		branch=sanitize_str(a[2])
	except Exception,e:
		res=re.split("\n",stout)[0]
		branch=re.split(" ",res)[3]
	return branch

def try_until_success(loops):
	global stout,sterr
	tries=0
	for i in range(0,loops):
		try:
			branch=get_current_branch()
			sys.stdout.write(branch)
			exit(0)
		except Exception, e:
			if i==(loops-1) or i==loops:raise
			if is_sterr_lock_file_error(sterr):continue
			else:raise
try:
	sleeps=0
	while(os.path.exists(".git/index.lock") and sleeps<5):
		sleeps+=1
		time.sleep(.2)
	if(os.path.exists(".git/index.lock")):os.unlink(".git/index.lock")
	try_until_success(4)
except Exception, e:
	sys.stderr.write("The current branch command threw this error: " + str(e))
	sys.stderr.write("\ncommand: %s\n" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	sys.stderr.write("\n\n\n")
	sys.stderr.write("\nstdout: "+stout)
	sys.stderr.write("\nsterr: "+sterr)
	exit(84)