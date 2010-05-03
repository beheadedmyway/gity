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
try:
	import time,subprocess,os,sys,re
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)

def not_on_branch(msg):
	if msg.find("Not currently on any branch") > -1: return True
	return False

def misc_error_occurred(sterr):
	if sterr.find("error: ") > -1: return True
	return False

def cant_push_to(sterr):
	if sterr.find("You can\'t push to") > -1: return True
	return False

def cant_push_to_newer_remote(sterr):
	if sterr.find("error: failed to push some refs") > -1: return True
	return False

def no_such_section(sterr):
	return (sterr.find("No such section!") > -1)

def exit_if_not_on_branch(msg):
	if not_on_branch(msg): exit(79)

def resources_dir():
	return "/".join(os.path.abspath(__file__).split("/")[0:-2])

def result_for_default_configs(gitbin):
	gitcommand="config --list | /usr/bin/grep ^gity.default.remote.branch"
	command="%s %s"%(gitbin,gitcommand)
	return run_command(command)

def unset_gity_default_remote(gitbin,remote):
	rcode,stout,sterr=result_for_default_configs(gitbin)
	rcode_for_git_exit(rcode,sterr)
	res=re.split("\n",stout)
	if len(res)>0:
		res.pop()
		cmds=[]
		for line in res:
			mat=re.search(remote,line)
			if not mat: continue
			a=line.split("=")
			b=a[0].split(".")
			branch=b[-1]
			cmd="%s config --unset-all gity.default.remote.branch.%s" % (gitbin,branch)
			cmds.append(cmd)
		for cmd in cmds: run_command(cmd)

def unset_gity_default_remote_for_branch(gitbin,branch):
	cmd="%s config --unset-all gity.default.remote.branch.%s" % (gitbin,branch)
	rcode,stout,sterr=run_command(cmd)
	rcode_for_git_exit(rcode,sterr)

def run_command(cmd):
	#returns (rcode,stdout,stderr)
	glog("command: "+cmd)
	process=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)
	stout=process.stdout.read()
	sterr=process.stderr.read()
	process.communicate() #this waits for the process to exit
	rcode=process.returncode
	return (rcode,stout,sterr)

def is_sterr_lock_file_error(sterr):
	return (sterr.find("Unable to create '.git/index.lock'")>-1)

def strip_trailing_slash(s):
	if s[-1] == "/": return s[0:len(s)-1]
	return s

def strip_leading_slash(s):
	if s[0] == "/": return s[1:len(s)]
	return s

def git_bin_version(gitbin):
	command="%s --version" % (gitbin)
	rcode,stout,sterr=run_command(command)
	return stout

def log_gitv(gitbin):
	try:
		gitv=git_bin_version(gitbin)
		sys.stderr.write("\n%s" % (gitv))
	except Exception, e: pass

def log_gity_version(gityversion):
	sys.stderr.write("\nGity Version: %s" % (gityversion))

def run_free_command(cmd):
	#returns (rcode,stdout,stderr)
	glog("free command: "+cmd)
	process=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True)

def make_vendor_tmp_dir():
	try: os.makedirs(".git/vendor/gity/tmp/")
	except Exception, e: pass

def make_gitignore():
	try: os.system("/usr/bin/touch .gitignore")
	except Exception, e: pass

def diff_report_file():
	return ".git/vendor/gity/tmp/diffreport"

def commit_report_file():
	return ".git/vendor/gity/tmp/commitreport"

def sanitize_str(s):
	if not s: raise Exception("Gity Error: A null strung came in through sanitize str")
	a=s.strip()
	return a

def is_empty(s):
	return s==""

def server_unreachable(msg):
	if msg.find("Cannot access URL") > -1: return True
	return False

def exit_if_server_unreachable(sterr):
	if server_unreachable(sterr):exit(86)

def exit_if_server_hungup(sterr):
	if server_hung_up(sterr):exit(85)

def exit_if_permission_denied(sterr):
	if permission_denied(sterr):exit(87)

def exit_if_host_verification_failed(sterr):
	if host_verification_failed(sterr):exit(88)

def permission_denied(msg):
	if msg.find("Permission denied") > -1: return True
	return False

def host_verification_failed(msg):
	if msg.find("Host key verification failed") > -1: return True
	return False

def kill_dupes(arry):
	d={}
	for x in arry:d[x]=x
	return d.values()

def raise_git_rescode_exception(rcode,sterr):
	raise Exception("Gity Error: git had an exit code greater than 1: %s %s" % (str(rcode),str(sterr)))

def rcode_for_git_exit(rcode,sterr):
	if is_sterr_lock_file_error(sterr): return
	if rcode > 1: raise_git_rescode_exception(rcode,sterr)

def already_exists(msg):
	return msg.find("already exists")

def server_hung_up(msg):
	if msg.find("The remote end hung up unexpectedly") > -1: return True
	return False

def glog(msg,force=False):
	if not force: return
	log=open("/Library/Logs/gity_python_log","a")
	log.write(str(msg)+"\n")
	log.close()

def make_file_list_for_git(files):
	a = ""
	for f in files:a+="'"+f.strip()+"' "
	return a

def checkfiles(options):
	if not options.files: return False
	return True

def wait_for(tm):
	time.sleep(tm)

def file_sort(x,y):
	return cmp(x.lower(), y.lower())