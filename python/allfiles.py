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
except Exception, e:
	sys.stderr.write(str(e))
	exit(84)
command=""
try:
	from _argv import *
	
	#get all files git knows about
	command="%s %s" % (options.git,"ls-files")
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	files=re.split("\n",stout)
	for c in range(0,len(files)):
		if is_empty(files[c]):files.pop(c)
	
	#get all untracked files
	command="%s ls-files -o --exclude-standard" % options.git
	rcode,stout,sterr=run_command(command)
	rcode_for_git_exit(rcode,sterr)
	ifiles = re.split("\n",stout)
	for c in range(0,len(ifiles)): 
		if is_empty(ifiles[c]):ifiles.pop(c)
	
	#merge the two file lists and sort
	files.extend(ifiles)
	files=kill_dupes(files)
	files.sort(file_sort)
	make_vendor_tmp_dir()
	allfilesFile=open(".git/vendor/gity/tmp/allfiles.json","w")
	allfilesFile.write(json.dumps(files))
	allfilesFile.close()
	sys.exit(0)
except Exception, e:
	sys.stderr.write("The allfiles command through this error: " + str(e))
	sys.stderr.write("\ncommand: %s" % command)
	log_gity_version(options.gityversion)
	log_gitv(options.git)
	exit(84)