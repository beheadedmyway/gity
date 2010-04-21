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
	import sys,re,subprocess,simplejson as json
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
command=""
try:
	from _argv import *
	allfiles = {}
	
	#UNTRACKED
	gitcommand = "ls-files -o --exclude-standard"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	files = re.split("\n",stout)
	for c in range(0,len(files)):
		if files[c] == "":files.pop(c)
	allfiles['untracked']=files
	
	#DELETED IN STAGE
	gitcommand = "diff-index HEAD --cached --name-status | /usr/bin/grep '^D'"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	deleted_in_stage=re.split("\n",stout)
	for c in range(0,len(deleted_in_stage)):
		deleted_in_stage[c] = re.sub("D\t","",deleted_in_stage[c])
		f = deleted_in_stage[c]
		if f == "":deleted_in_stage.pop(c)
	allfiles['stage_deleted']=deleted_in_stage
	
	#DELETED FILES
	gitcommand="ls-files -d"
	command="%s %s"%(options.git,gitcommand)
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	deleted_files=re.split("\n",stout)
	kills=[]
	for c in range(0,len(deleted_files)):
		f=deleted_files[c]
		if f == "":
			deleted_files.pop(c)
			continue
		try:
			if deleted_in_stage.index(f) > -1: kills.append(f)
		except Exception,e: pass
	for fl in kills:
		try: deleted_files.remove(fl)
		except Exception,e: pass
	allfiles['deleted'] = deleted_files
	
	#MODIFIED IN STAGE
	gitcommand = "diff-index HEAD --cached --name-status | /usr/bin/grep '^M'"
	command = "%s %s" % (options.git,gitcommand)
	process = subprocess.Popen(command,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	stout = process.stdout.read()
	sterr = process.stderr.read()
	process.communicate()
	rcode = process.returncode
	rcode_for_git_exit(rcode,sterr)
	subs_mod_stage=[]
	modified_in_stage = re.split("\n",stout)
	for c in range(0,len(modified_in_stage)):
		f=modified_in_stage[c]
		f=re.sub("M\t","",f)
		modified_in_stage[c]=f
		if f == "":modified_in_stage.pop(c)
	allfiles['stage_modified'] = modified_in_stage
	
	#UNMERGED
	gitcommand = "diff-files --name-status | /usr/bin/grep '^U'"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	unmergedfiles = re.split("\n",stout)
	for c in range(0,len(unmergedfiles)):
		unmergedfiles[c] = re.sub("U\t","",unmergedfiles[c])
		if unmergedfiles[c] == "":unmergedfiles.pop(c)
	allfiles['unmerged'] = unmergedfiles
	
	#MODIFIED FILES
	gitcommand = "ls-files -m"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	files = re.split("\n",stout)
	kills=[]
	mod={}
	for c in range(0,len(files)):
		f=files[c]
		if f == "":
			files.pop(c)
			continue
	files = kill_dupes(files)
	allfiles['modified']=files
	
	#ADDED IN STAGE
	gitcommand = "diff-index HEAD --cached --name-status | /usr/bin/grep '^A'"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	files = re.split("\n",stout)
	for c in range(0,len(files)):
		files[c]=re.sub("A\t","",files[c])
		if files[c]=="":files.pop(c)
	allfiles['stage_add'] = files
	
	make_vendor_tmp_dir()
	statusFile=open(".git/vendor/gity/tmp/status.json","w")
	statusFile.write(json.dumps(allfiles))
	statusFile.close()
	exit(0)
except Exception, e:
	sys.stderr.write("The status command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)