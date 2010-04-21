import re,os

os.system("java -jar scripts/yui/build/yuicompressor-2.4.2.jar --type js -o diff/gity_min.js diff/gity.js")
os.system("java -jar scripts/yui/build/yuicompressor-2.4.2.jar --type css -o diff/diff_min.css diff/diff.css")

template=open("diff/template.html")
template_content=template.read()

gityjs=open("diff/gity_min.js")
gityjs_content=gityjs.read()

jquery=open("diff/jquery.js")
jquery_content=jquery.read()

css=open("diff/diff_min.css")
css_content=css.read()

final=re.sub("{css}",css_content,template_content)
final=gityjs_content.join(final.split("@gity@"))
final=jquery_content.join(final.split("@jquery@"))

out=open("diff/parsed_template.html","w")
out.write(final)

out2=open("assets/cancelDown.png","w")
out2.write(final)