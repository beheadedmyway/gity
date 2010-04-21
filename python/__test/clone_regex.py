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

urls = []
urls.append("git://github.com/g1zm0duck/test.git")
urls.append("git@github.com:g1zm0duck/test.git")
urls.append("git@github.com:g1zm0duck/word/test12.git")
urls.append("git@github.com:g1zm0duck/word/test12.git")
urls.append("file:///word/test12.git")
urls.append("/word/test12.git/")
urls.append("/word/test14.git/")
urls.append("rsync://host.xz/path/to/test4.git/")
urls.append("http://host.xz:8080/path/to/test5.git/")
urls.append("git://host.xz[:port]/path/to/test6.git/")
urls.append("git://host.xz:9087/path/to/test7.git/")
urls.append("git://host.xz[:port]/~user/path/to/test8.git/")
urls.append("ssh://[user@]host.xz[:port]/path/to/test9.git/")
urls.append("ssh://user@host.xz:9088/path/to/test9.git/")
urls.append("ssh://user@host.xz:9088]/path/to/test10.git/")
urls.append("ssh://[user@]host.xz/~user/path/to/test11.git/")
urls.append("ssh://[user@]host.xz/ ~user/path/to/test1 1.git/")
urls.append("ssh://[user@]host.xz/ ~user/path/to/test1_1.git/")
urls.append("ssh://[user@]host.xz/ ~user/path/to/test1 _1.git/")
urls.append("ssh://[user@]host.xz/ ~user/path/to/__st1 _1.git/")
urls.append("ssh://[user@]host.xz/ ~user/path/to/_90_st1 _1.git/")

for url in urls:
	match=re.search("([a-zA-Z0-9_ ]*)\.git",url)
	print "repo name: %s" % (match.group(1))