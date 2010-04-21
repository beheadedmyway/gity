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
	output={}
	refs=[]
	
	#has submodules in __tmp
	gitcommand = "submodule status"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	lines=re.split("\n",stout)
	lines.pop()
	subs=[]
	subslook={}
	for line in lines:
		line=line[1:]
		a=re.split(" ",line)
		fullsubname=a[1]
		subname=fullsubname.split("/")[-1]
		subs.append({"name":subname,"spec":fullsubname})
	output['submodules']=subs
	
	#remotes
	gitcommand = "remote -v show"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	finals = []
	names = {}
	res=re.split("\n",stout)
	if len(res) > 0:
		res.pop()
		for line in res:
			l=sanitize_str(line)
			a=re.split("\t",l)
			name=sanitize_str(a[0])
			url=sanitize_str(re.split(" ",a[1])[0])
			if names.get(name,False): continue
			finals.append({"name":name,"url":url})
			names[name]=True
	output["remotes"]=finals
	
	#stash
	gitcommand="stash list"
	command="%s %s"%(options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	finals=[]
	names={}
	res=re.split("\n",stout)
	if len(res) > 0:
		res.pop()
		for line in res:
			splits=line.split(":")
			name=sanitize_str(splits[-1])
			branch=sanitize_str(splits[1])[3:]
			if len(name)>24:name=name[0:24]+"..."
			finals.append({'name':name,'branch':branch})
	output["stashes"]=finals
	
	#branches
	gitcommand = "branch"
	command = "%s %s" % (options.git,gitcommand)
	rcode,stout,sterr = run_command(command)
	rcode_for_git_exit(rcode,sterr)
	res=re.split("\n",stout)
	branches=[]
	if len(res) > 0:
		res.pop()
		for line in res:
			if line.find("(no branch)") > -1: continue
			l=sanitize_str(line)
			l=re.sub("\*","",l)
			l=sanitize_str(l)
			branches.append(l)
	if len(branches)<1:branches=["master"] #the repo was just initialized.
	output["branches"]=branches
	refs.extend(branches)
	
	#remote branches
	command = "%s %s" % (options.git,"branch -r")
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	remote_branches = []
	res=re.split("\n",stout)
	if res[-1] == "": res.pop()
	for line in res:
		branch=sanitize_str(line)
		if branch.find("->") > -1: continue
		try:
			if remote_branches.index(line) > -1: continue;
		except: pass
		remote_branches.append(branch)
	output['remote_branches']=remote_branches
	refs.extend(remote_branches)
	
	#tags
	gitcommand="tag -l"
	command="%s %s"%(options.git,gitcommand)
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	res=re.split("\n",stout)
	tags=[]
	if len(res) > 0:
		res.pop()
		for line in res:
			tag=sanitize_str(line)
			tags.append(tag)
	output["tags"]=tags
	refs.extend(tags)
	
	output["refs"]={}
	if len(refs) > 0:
		gitcommand="rev-parse"
		command="%s %s %s"%(options.git,gitcommand, " ".join(refs))
		rcode,stout,sterr=run_command(command)
		rcode_for_git_exit(rcode,sterr)
		res=re.split("\n",stout)
		refshas={}
		if len(res) > 0:
			res.pop()
			for line in res:
				sha=sanitize_str(line)
				refshas[refs.pop(0)]=sha
		output["refs"]=refshas
	
	#default remotes
	rcode,stout,sterr=result_for_default_configs(options.git)
	rcode_for_git_exit(rcode,sterr)
	dremotes={}
	lines=re.split("\n",stout)
	if len(lines) > 0:
		lines.pop()
		for line in lines:
			a=line.split("=")
			parts=a[-2].split(".")
			branch=parts[-1]
			remote=a[-1]
			dremotes[sanitize_str(str(branch))]=sanitize_str(str(remote))
	output["default_remotes"]=dremotes
	
	make_vendor_tmp_dir()
	statusFile=open(".git/vendor/gity/tmp/metastatus.json","w")
	statusFile.write(json.dumps(output))
	statusFile.close()
	exit(0)
except Exception, e:
	sys.stderr.write("The meta status command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	sys.stderr.write("\n\n\n")
	sys.stderr.write("\nstdout: "+stout)
	sys.stderr.write("\nsterr: "+sterr)
	exit(84)
