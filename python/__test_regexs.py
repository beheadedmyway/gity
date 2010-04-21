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

import re
def verifyRemote(remote):
	#[a-zA-Z0-9_-\./]+/?*.git/?$
	if(re.match("^rsync://[\/a-zA-Z0-9_-]+/?.*\.git/?$",remote)): return True
	if(re.match("^http[s]?://[\/a-zA-Z0-9_-]+(\:?[0-9]{1,6})?/?.*\.git/?$",remote)): return True
	return False

print verifyRemote("rsync://codeendeavor.com/git/gitty.git")
print verifyRemote("rsync://codeendeavor.com/git/gitty.git/")
print verifyRemote("http://git.codeendeavor.com:90/git/gitty.git/")
print verifyRemote("https://git.codeendeavor.com:90/git/gitty.git/")