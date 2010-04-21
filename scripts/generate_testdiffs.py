import os
os.system("python scripts/createdifftemplate.py")
for i in range(1,100):
	try:
		diff=str(i)
		template=open("diff/parsed_template.html")
		template_content=template.read()
		diff_file=open("diff/tests/diffs/%s" % (str(diff)))
		diff_content=diff_file.read()
		diff_test=diff_content.join(template_content.split("@content@"))
		out=open("diff/tests/%s.html" % (str(diff)),"w")
		out.write(diff_test)
	except: break