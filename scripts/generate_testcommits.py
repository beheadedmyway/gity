import os
os.system("python scripts/createcommittemplate.py")
for i in range(1,100):
	try:
		commit=str(i)
		template=open("diff/parsed_commit_template.html")
		template_content=template.read()
		commit_file=open("diff/test_commits/commits/%s" % (str(commit)))
		commit_content=commit_file.read()
		commit_test=commit_content.join(template_content.split("@content@"))
		out=open("diff/test_commits/%s.html" % (str(commit)),"w")
		out.write(commit_test)
	except: break