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
try:
	from _argv import *
	#m = 0 head vs working tree
	#m = 1 head vs stage (--cached)
	#m = 2 stage vs working tree
	
	filelist = None
	if not options.misc:
		options.misc=[]
		options.misc[0]="0"
		options.misc[1]="3"
	
	diffval=sanitize_str(options.misc[0])
	context=sanitize_str(options.misc[1])
	if options.files: filelist=make_file_list_for_git(options.files)
	
	if diffval == "0": command="%s diff -U%s" % (options.git,context)
	if diffval == "1": command="%s diff --cached -U%s" % (options.git,context)
	if diffval == "2": command="%s diff -U%s" % (options.git,context)
	if filelist: command += " %s" % (filelist)
	
	if filelist and diffval == "2" and len(options.files) == 2 and options.files[0] == options.files[1]:
		command="%s diff-files -U%s %s" %(options.git,context,filelist)
	
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	make_vendor_tmp_dir()
	if(options.changedir): resources="assets"
	else: resources=resources_dir()
	template=open(resources+"/cancelDown.png","r")
	template_content=template.read()
	template.close()
	
	stout=re.sub("<","&lt;",stout)
	stout=re.sub(">","&gt;",stout)
	
	a=template_content.split("@content@")
	final=stout.join(a)
	tmp=open(".git/vendor/gity/tmp/diff.html","w")
	tmp.write(final)
	tmp.close()
	exit(0)
except Exception, e:
	sys.stderr.write("The diff command through this error: " + str(e))
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)