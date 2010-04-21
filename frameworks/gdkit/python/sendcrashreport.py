try:
	import sys,re,os,subprocess,smtplib
	from optparse import OptionParser
except Exception,e:
	exit(100)

options=None
args=None
try:
	usage = "usage: sendcrashreport.py -f /Library/Logs/CrashReports/MyFile.crash [-c /tmp/myvile"
	parser=OptionParser(usage=usage)
	parser.add_option("-f",dest="file",help="the core dump file to send")
	parser.add_option("-c",dest="comments",help="The file that contains the extra comments")
	(options,args)=parser.parse_args()
except Exception, e:
	sys.stderr.write(e)
	exit(0)

try:
	from email.MIMEMultipart import MIMEMultipart
	from email.MIMEBase import MIMEBase
	from email.MIMEText import MIMEText
	from email import Encoders
except Exception,e:
	sys.stderr.write(e)
	exit(0)

try:
	corefile=options.file.lstrip().rstrip()
	comments=options.comments
	if(comments): comments = comments.lstrip().rstrip()
	if not corefile: exit(0)
	if not os.path.exists(corefile): exit(0)
	if comments and not os.path.exists(comments): comments=False
	msg=MIMEMultipart()
	msg['From']="gitybot@macendeavor.com"
	msg['To']="support@macendeavor.com"
	msg['Subject']="GityBot: Crash Report"
	if comments: msg.attach(MIMEText( open(comments,"r").read() ))
	else: msg.attach(MIMEText(" "))
	part=MIMEBase('application','octet-stream')
	part.set_payload(open(corefile,'rb').read())
	Encoders.encode_base64(part)
	part.add_header('Content-Disposition','attachment; filename="%s"' % corefile.split("/")[-1])
	msg.attach(part)
	mailServer=smtplib.SMTP("smtp.gmail.com",587)
	mailServer.ehlo()
	mailServer.starttls()
	mailServer.ehlo()
	mailServer.login('gitybot@macendeavor.com','')
	mailServer.sendmail('gitybot@macendeavor.com','support@macendeavor.com',msg.as_string())
	mailServer.close()
	if comments: os.unlink(comments)
except Exception,e:
	sys.stderr.write(str(e))
	exit(0)
