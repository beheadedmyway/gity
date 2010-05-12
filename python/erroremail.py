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
from _argv import *
try:
	import sys,re,os,subprocess,smtplib
	from email.mime.text import MIMEText
except Exception,e:
	sys.stderr.write(str(e))
	exit(84)
errors=open(".git/vendor/gity/tmp/errors","r")
content=errors.read()
errors.close()
try:
	exit(0)
	msg=MIMEText(content)
	msg['Subject'] = "Gity Bot: Error"
	mailServer=smtplib.SMTP("smtp.gmail.com",587)
	mailServer.ehlo()
	mailServer.starttls()
	mailServer.ehlo()
	mailServer.login('gitybot@macendeavor.com','')
	mailServer.sendmail('gitybot@macendeavor.com','support@macendeavor.com',msg.as_string())
	mailServer.close()
except Exception,e:
	pass