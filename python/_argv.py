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

#exit code of 84 shows the unknown error view
try:
	import os,sys
	from optparse import OptionParser
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
try:
	options=None
	args=None
	usage = "usage: _argv.py -g /usr/bin/git -c status -p /path/to/git/project -f . [ | -f path/to/file/in/project.txt | -f path/to/file/in/project.txt -f another/path/to/file/in/project.txt]"
	parser=OptionParser(usage=usage)
	parser.add_option("-g","--git",dest="git",help="the git binary")
	parser.add_option("-p","--path",dest="path",help="the git repo path")
	parser.add_option("-m","--misc",dest="misc",action="append",help="miscellaneous extra git parameters ( --, HEAD:4ro49ei ) etc")
	parser.add_option("-f","--files",dest="files",action="append",help="A list of files to operate on")
	parser.add_option("-r","--repo",dest="repo",action="store",help="a repo to clone")
	parser.add_option("-c",dest="changedir",action="store",help="change directories")
	parser.add_option("-v",dest="gityversion",action="store",help="the gity version for logging and error output")
	(options,args)=parser.parse_args()
	if not options.git:
		glog(">>missing git binary parameter")
		raise Exception("Gity Error: Missing git binary location parameter")
	if not options.repo and not options.path:
		glog(">>missing git repo path")
		raise Exception("Gity Error: Missing the git project path")
	if options.changedir: os.chdir(options.path)
except Exception, e:
	glog(str(e))
	sys.stderr.write("The _argv command threw this error: " + str(e))
	exit(8000)