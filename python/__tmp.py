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

#SUBMODULES

#gitcommand = "submodule status"
#command = "%s %s" % (options.git,gitcommand)
#rcode,stout,sterr = run_command(command)
#rcode_for_git_exit(rcode,sterr)
#lines=re.split("\n",stout)
#lines.pop()
#subs=[]
#subslook={}
#for line in lines:
#	line=line[1:]
#	a=re.split(" ",line)
#	subname=a[1]
#	subs.append(a[1])
#	subslook[subname]=True
#allfiles['submodules']=subs



#REMOTE BRANCHES
#gitcommand = "branch -r"
#command = "%s %s" % (options.git,gitcommand)
#rcode,stout,sterr = run_command(command)
#rcode_for_git_exit(rcode,sterr)
#finals = {}
#res=re.split("\n",stout)
#if res[-1] == "": res.pop()
#for line in res:
#	a = line.split("/")
#	remote = a[0].lstrip().rstrip()
#	if not finals.get(remote,False): finals[remote]=[]
#	branch = a[1].lstrip().rstrip()
#	finals[remote].append(branch)
#	#finals.append({"remote":remote,"branch":branch})
#output["remote_branches"] = finals
#output["remote_branches"] = {}
#sys.stdout.write(json.dumps(finals))