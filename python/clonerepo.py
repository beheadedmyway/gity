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
	destination=os.getcwd()
	repo_to_open=destination
	clone_into=True
	if len(os.listdir(destination)) > 0: clone_into=False
	if clone_into: command="%s %s %s %s"%(options.git,"clone --recursive",sanitize_str(options.repo),".")
	else:
		command="%s %s %s"%(options.git,"clone --recursive",sanitize_str(options.repo))
		match=re.search("([-a-zA-Z0-9_]*)\.git",options.repo)
		repo=match.group(1)
		repo_to_open=destination+"/"+repo
	rcode,stout,sterr=run_command(command)
	exit_if_permission_denied(sterr)
	exit_if_host_verification_failed(sterr)
	exit_if_server_unreachable(sterr)
	exit_if_server_hungup(sterr)
	rcode_for_git_exit(rcode,sterr)
	os.chdir(repo_to_open);
	if sterr.find("You appear to have cloned an empty repository") > -1:
		try:
			command="%s %s --allow-empty -m 'New repository'"%(options.git,"commit")
			rcode,stout,sterr=run_command(command)
		except Exception,e: pass
	command="%s %s -r" % (options.git,"branch")
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	lines=re.split("\n",stout)
	lines.pop()
	commands=[]
	try:
		for line in lines:
			if line.find("->") > -1: continue
			if line.find("origin/master") > -1: continue
			a=line.split("/")
			remote=a[0]
			branch=a[1]
			commands.append("%s %s --track %s %s/%s"%(options.git,"branch",branch,remote,branch))
		for cmd in commands:
			rcode,stout,sterr=run_command(cmd)
			rcode_for_git_exit(rcode,sterr)
	except Exception,e: pass
	sys.stdout.write(repo_to_open)
	exit(0)
except Exception, e:
	sys.stderr.write("The clone repo command threw this error: " + str(e))
	sys.stderr.write("\ncommand: %s\n" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)