// Copyright Aaron Smith 2009
// 
// This file is part of Gity.
// 
// Gity is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Gity is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with Gity. If not, see <http://www.gnu.org/licenses/>.

var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
var lines;
var l;
var nl;
var nnl;
var nnnl;
var k=0;
var i=0;
var linkCount = 0;
var isCommitDetails=false;
var commitDetails={}
var commitDetailsTable;
var commitDetailFiles = {};
var commitDetailsTableContent = [];

/**
*
*  MD5 (Message-Digest Algorithm)
*  http://www.webtoolkit.info/
*
**/
 
var MD5 = function (string) {
 
	function RotateLeft(lValue, iShiftBits) {
		return (lValue<<iShiftBits) | (lValue>>>(32-iShiftBits));
	}
 
	function AddUnsigned(lX,lY) {
		var lX4,lY4,lX8,lY8,lResult;
		lX8 = (lX & 0x80000000);
		lY8 = (lY & 0x80000000);
		lX4 = (lX & 0x40000000);
		lY4 = (lY & 0x40000000);
		lResult = (lX & 0x3FFFFFFF)+(lY & 0x3FFFFFFF);
		if (lX4 & lY4) {
			return (lResult ^ 0x80000000 ^ lX8 ^ lY8);
		}
		if (lX4 | lY4) {
			if (lResult & 0x40000000) {
				return (lResult ^ 0xC0000000 ^ lX8 ^ lY8);
			} else {
				return (lResult ^ 0x40000000 ^ lX8 ^ lY8);
			}
		} else {
			return (lResult ^ lX8 ^ lY8);
		}
 	}
 
 	function F(x,y,z) { return (x & y) | ((~x) & z); }
 	function G(x,y,z) { return (x & z) | (y & (~z)); }
 	function H(x,y,z) { return (x ^ y ^ z); }
	function I(x,y,z) { return (y ^ (x | (~z))); }
 
	function FF(a,b,c,d,x,s,ac) {
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(F(b, c, d), x), ac));
		return AddUnsigned(RotateLeft(a, s), b);
	};
 
	function GG(a,b,c,d,x,s,ac) {
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(G(b, c, d), x), ac));
		return AddUnsigned(RotateLeft(a, s), b);
	};
 
	function HH(a,b,c,d,x,s,ac) {
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(H(b, c, d), x), ac));
		return AddUnsigned(RotateLeft(a, s), b);
	};
 
	function II(a,b,c,d,x,s,ac) {
		a = AddUnsigned(a, AddUnsigned(AddUnsigned(I(b, c, d), x), ac));
		return AddUnsigned(RotateLeft(a, s), b);
	};
 
	function ConvertToWordArray(string) {
		var lWordCount;
		var lMessageLength = string.length;
		var lNumberOfWords_temp1=lMessageLength + 8;
		var lNumberOfWords_temp2=(lNumberOfWords_temp1-(lNumberOfWords_temp1 % 64))/64;
		var lNumberOfWords = (lNumberOfWords_temp2+1)*16;
		var lWordArray=Array(lNumberOfWords-1);
		var lBytePosition = 0;
		var lByteCount = 0;
		while ( lByteCount < lMessageLength ) {
			lWordCount = (lByteCount-(lByteCount % 4))/4;
			lBytePosition = (lByteCount % 4)*8;
			lWordArray[lWordCount] = (lWordArray[lWordCount] | (string.charCodeAt(lByteCount)<<lBytePosition));
			lByteCount++;
		}
		lWordCount = (lByteCount-(lByteCount % 4))/4;
		lBytePosition = (lByteCount % 4)*8;
		lWordArray[lWordCount] = lWordArray[lWordCount] | (0x80<<lBytePosition);
		lWordArray[lNumberOfWords-2] = lMessageLength<<3;
		lWordArray[lNumberOfWords-1] = lMessageLength>>>29;
		return lWordArray;
	};
 
	function WordToHex(lValue) {
		var WordToHexValue="",WordToHexValue_temp="",lByte,lCount;
		for (lCount = 0;lCount<=3;lCount++) {
			lByte = (lValue>>>(lCount*8)) & 255;
			WordToHexValue_temp = "0" + lByte.toString(16);
			WordToHexValue = WordToHexValue + WordToHexValue_temp.substr(WordToHexValue_temp.length-2,2);
		}
		return WordToHexValue;
	};
 
	function Utf8Encode(string) {
		string = string.replace(/\r\n/g,"\n");
		var utftext = "";
 
		for (var n = 0; n < string.length; n++) {
 
			var c = string.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
	};
 
	var x=Array();
	var k,AA,BB,CC,DD,a,b,c,d;
	var S11=7, S12=12, S13=17, S14=22;
	var S21=5, S22=9 , S23=14, S24=20;
	var S31=4, S32=11, S33=16, S34=23;
	var S41=6, S42=10, S43=15, S44=21;
 
	string = Utf8Encode(string);
 
	x = ConvertToWordArray(string);
 
	a = 0x67452301; b = 0xEFCDAB89; c = 0x98BADCFE; d = 0x10325476;
 
	for (k=0;k<x.length;k+=16) {
		AA=a; BB=b; CC=c; DD=d;
		a=FF(a,b,c,d,x[k+0], S11,0xD76AA478);
		d=FF(d,a,b,c,x[k+1], S12,0xE8C7B756);
		c=FF(c,d,a,b,x[k+2], S13,0x242070DB);
		b=FF(b,c,d,a,x[k+3], S14,0xC1BDCEEE);
		a=FF(a,b,c,d,x[k+4], S11,0xF57C0FAF);
		d=FF(d,a,b,c,x[k+5], S12,0x4787C62A);
		c=FF(c,d,a,b,x[k+6], S13,0xA8304613);
		b=FF(b,c,d,a,x[k+7], S14,0xFD469501);
		a=FF(a,b,c,d,x[k+8], S11,0x698098D8);
		d=FF(d,a,b,c,x[k+9], S12,0x8B44F7AF);
		c=FF(c,d,a,b,x[k+10],S13,0xFFFF5BB1);
		b=FF(b,c,d,a,x[k+11],S14,0x895CD7BE);
		a=FF(a,b,c,d,x[k+12],S11,0x6B901122);
		d=FF(d,a,b,c,x[k+13],S12,0xFD987193);
		c=FF(c,d,a,b,x[k+14],S13,0xA679438E);
		b=FF(b,c,d,a,x[k+15],S14,0x49B40821);
		a=GG(a,b,c,d,x[k+1], S21,0xF61E2562);
		d=GG(d,a,b,c,x[k+6], S22,0xC040B340);
		c=GG(c,d,a,b,x[k+11],S23,0x265E5A51);
		b=GG(b,c,d,a,x[k+0], S24,0xE9B6C7AA);
		a=GG(a,b,c,d,x[k+5], S21,0xD62F105D);
		d=GG(d,a,b,c,x[k+10],S22,0x2441453);
		c=GG(c,d,a,b,x[k+15],S23,0xD8A1E681);
		b=GG(b,c,d,a,x[k+4], S24,0xE7D3FBC8);
		a=GG(a,b,c,d,x[k+9], S21,0x21E1CDE6);
		d=GG(d,a,b,c,x[k+14],S22,0xC33707D6);
		c=GG(c,d,a,b,x[k+3], S23,0xF4D50D87);
		b=GG(b,c,d,a,x[k+8], S24,0x455A14ED);
		a=GG(a,b,c,d,x[k+13],S21,0xA9E3E905);
		d=GG(d,a,b,c,x[k+2], S22,0xFCEFA3F8);
		c=GG(c,d,a,b,x[k+7], S23,0x676F02D9);
		b=GG(b,c,d,a,x[k+12],S24,0x8D2A4C8A);
		a=HH(a,b,c,d,x[k+5], S31,0xFFFA3942);
		d=HH(d,a,b,c,x[k+8], S32,0x8771F681);
		c=HH(c,d,a,b,x[k+11],S33,0x6D9D6122);
		b=HH(b,c,d,a,x[k+14],S34,0xFDE5380C);
		a=HH(a,b,c,d,x[k+1], S31,0xA4BEEA44);
		d=HH(d,a,b,c,x[k+4], S32,0x4BDECFA9);
		c=HH(c,d,a,b,x[k+7], S33,0xF6BB4B60);
		b=HH(b,c,d,a,x[k+10],S34,0xBEBFBC70);
		a=HH(a,b,c,d,x[k+13],S31,0x289B7EC6);
		d=HH(d,a,b,c,x[k+0], S32,0xEAA127FA);
		c=HH(c,d,a,b,x[k+3], S33,0xD4EF3085);
		b=HH(b,c,d,a,x[k+6], S34,0x4881D05);
		a=HH(a,b,c,d,x[k+9], S31,0xD9D4D039);
		d=HH(d,a,b,c,x[k+12],S32,0xE6DB99E5);
		c=HH(c,d,a,b,x[k+15],S33,0x1FA27CF8);
		b=HH(b,c,d,a,x[k+2], S34,0xC4AC5665);
		a=II(a,b,c,d,x[k+0], S41,0xF4292244);
		d=II(d,a,b,c,x[k+7], S42,0x432AFF97);
		c=II(c,d,a,b,x[k+14],S43,0xAB9423A7);
		b=II(b,c,d,a,x[k+5], S44,0xFC93A039);
		a=II(a,b,c,d,x[k+12],S41,0x655B59C3);
		d=II(d,a,b,c,x[k+3], S42,0x8F0CCC92);
		c=II(c,d,a,b,x[k+10],S43,0xFFEFF47D);
		b=II(b,c,d,a,x[k+1], S44,0x85845DD1);
		a=II(a,b,c,d,x[k+8], S41,0x6FA87E4F);
		d=II(d,a,b,c,x[k+15],S42,0xFE2CE6E0);
		c=II(c,d,a,b,x[k+6], S43,0xA3014314);
		b=II(b,c,d,a,x[k+13],S44,0x4E0811A1);
		a=II(a,b,c,d,x[k+4], S41,0xF7537E82);
		d=II(d,a,b,c,x[k+11],S42,0xBD3AF235);
		c=II(c,d,a,b,x[k+2], S43,0x2AD7D2BB);
		b=II(b,c,d,a,x[k+9], S44,0xEB86D391);
		a=AddUnsigned(a,AA);
		b=AddUnsigned(b,BB);
		c=AddUnsigned(c,CC);
		d=AddUnsigned(d,DD);
	}
 
	var temp = WordToHex(a)+WordToHex(b)+WordToHex(c)+WordToHex(d);
 
	return temp.toLowerCase();
}

function startDiff()
{
	var diff=$("#diff");
	var safeDiff=diff.val().replace(/\&/g,"&amp;");
	safeDiff=safeDiff.replace(/</g,"&lt;");
	$("#updateddiff").html(safeDiff);
	highlightDiffs();
}

function startCommit()
{
	commitDetailsTableContent=[];
	commitDetailFiles['changed']=[];
	commitDetailFiles['removed']=[];
	commitDetailFiles['new']=[];
	commitDetailFiles['renamed']=[];
	commitDetailsTable=$("#commitDetailsTable");
	commitRawMessageDiv=$("#commitMessageContainer");
	isCommitDetails=true;
	parseCommitDetails();
    addAuthorImage();
	addAuthor();
	addCommitter();
	addDate();
	addSubject();
	addRefs();
	addSHA();
	//addTree();
	addParents();
	//addOptions();
	//addDiff();
	addRawMessage();
	updateCommitTableContent();
	startDiff();
	updateCommitFiles();
}

function updateCommitTableContent()
{
	commitDetailsTable.append(commitDetailsTableContent.join(""));
}

function exportTar()
{
	if(window.historyDetailsView) window.historyDetailsView.exportTar();
}

function exportZip(ref)
{
	if(window.historyDetailsView) window.historyDetailsView.exportZip();
}

function loadLeft()
{
	if(window.historyDetailsView) window.historyDetailsView.loadLeft_(commitDetails.fullSHA);
}

function loadRight()
{
	if(window.historyDetailsView) window.historyDetailsView.loadRight_(commitDetails.fullSHA);
}

function loadParent(hash)
{
	if(window.historyDetailsView) window.historyDetailsView.loadParent_(hash);
}

function newTag(hash)
{
	if(window.historyDetailsView) window.historyDetailsView.newTag_(hash);
}

function cherryPick(hash)
{
	if(window.historyDetailsView) window.historyDetailsView.cherryPick_(hash);
}

function loadTree(tree)
{
	if(window.historyDetailsView) window.historyDetailsView.loadTree_(tree);
}

function nextLineIsAllSpaces()
{
	if(!nl) return false;
	if(nl.match(/^\s{0,}$/)) return true;
	return false;
}

function isLineIsAllSpaces()
{
	var line=lines[i];
	if(line.match(/^\s{0,}$/)) return true;
	return false;
}

function isNewFile(line)
{
	if(!line) return false;
	return (line.match("^[a-zA-Z0-9_]*")[0].toLowerCase()=="new");
}

function isDeletedFile(line)
{
	if(!line) return false;
	return (line.match("^[a-zA-Z0-9_]*")[0].toLowerCase()=="deleted");
}

function stepOverALine()
{
	var c=i+2;
	if(lines.length-1<c)return null;
	return lines[c];
}

function isNextLineNewFile()
{
	if(!nl) return false;
	return isNewFile(nl);
}

function isNextLineDeletedFile()
{
	if(!nl) return false;
	return isDeletedFile(nl);
}

function isThisFileBinary()
{
	if(!nnl) return false;
	return (nnl.match("^[a-zA-Z0-9_]*")[0].toLowerCase()=="binary");
}

function isNewBinaryFile()
{
	if(!nnnl) return false;
	return (nnnl.match("^[a-zA-Z0-9_]*")[0].toLowerCase()=="binary");
}

function isFileNoContent()
{
	if(!nnl) return false;
	if(nnl.match("^diff") || nnnl.match("^diff")) return true;
	if(nnnl=="") return true;
	return false;
}

function isRenamedFile()
{
	if(nnl.match("^rename from") && nnnl.match("^rename to")) return true;
	return false;
}

function isLineTooLong()
{
	return (l.length > 24887)
}

function parseCommitDetails()
{
	var details=$("#commitDetails");
	var safeDetails=details.val().replace(/\&/g,"&amp;");
	safeDetails=safeDetails.replace(/</g,"&lt;");
	var startDiff=safeDetails.indexOf("\ndiff ");
	var messageStart=safeDetails.indexOf("\n\n") + 2;
	if(startDiff == -1) startDiff=safeDetails.length;
	var diffContent=safeDetails.substring(startDiff);
	$("#diff").html(diffContent);
	var headerContent=safeDetails.substring(0,startDiff);
	//first grab author
	var match=headerContent.match(/\nauthor (.*) \&lt\;(.*@.*|.*)> ([0-9].*)/);
	commitDetails.author=match[1];
	commitDetails.authorEmail=match[2];
	//if(!(match[2].match(/@[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/))) commitDetails.authorEmail=match[2];
	//now grab committer
	match=headerContent.match(/\ncommitter (.*) \&lt\;(.*@.*|.*)> ([0-9].*)/);
	commitDetails.committer=match[1];
	commitDetails.committerEmail=match[2];
	//date is taken from committer
	commitDetails.date=new Date(parseInt(match[3])*1000);
	//find commit info
	match=headerContent.match("^commit ([a-zA-Z0-9]*)\n");
	commitDetails.fullSHA=match[1];
	commitDetails.sha=match[1].substring(0,10);
	//find tree info
	match=headerContent.match("tree ([a-zA-Z0-9]*)\n");
	commitDetails.tree=match[1];
	//find parents
	match=headerContent.match(/^parent ([a-zA-Z0-9]*)\n/gm);
	commitDetails.parents=[];
	if(match)
	{
		var i=0;
		var l=match.length;
		var parent="";
		for(i;i<l;i++)
		{
			parent=match[i].split(" ")[1];
			commitDetails.parents.push(parent);
		}
	}
	var rawMessage=safeDetails.substring(messageStart,startDiff).replace(/^    /gm, "");
	commitDetails.rawMessage=rawMessage;
	commitDetails.subject=rawMessage.split("\n\n")[0].replace(/^    /gm, "");
}

function updateCommitFiles()
{
	var i=0;
	var l;
	var n;
	var obj;
	var clearedCommitIndex=false;
	
	var fileCount=commitDetailFiles['new'].length + commitDetailFiles['renamed'].length + commitDetailFiles['changed'].length + commitDetailFiles['removed'].length;
	if(commitDetails.rawMessage.match("^Merge branch") && fileCount < 1)
	{
		clearedCommitIndex=true;
		$("#commitIndex").html("");
	}
	if(fileCount<1 && !clearedCommitIndex)
	{
		$("#commitIndex").html("");
		return;
	}
	if(commitDetailFiles['new'].length>0)
	{
		i=0;
		n=[];
		l=commitDetailFiles['new'].length;
		n.push("<table id='fileStatuses' class='monaco'><tr><td><span class='fileStatus newFileStatus'>New</span><div id='spacer'>&nbsp;</div></td></tr>");
		n.push("<tr><td><ul class='fileStatusList'>")
		for(i;i<l;i++)
		{
			obj=commitDetailFiles['new'][i];
			if(!obj.binary) n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"' class='file'>"+ obj.file +"</a></li>");
			else n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"' class='file'>"+ obj.file +"</a> (binary)</li>");
		}
		n.push("</ul></td></tr></table>");
		$("#fileStatusesContainer").append(n.join(""));
	}
	if(commitDetailFiles['renamed'].length>0)
	{
		i=0;
		n=[];
		l=commitDetailFiles['renamed'].length;
		n.push("<table id='fileStatuses' class='monaco'><tr><td><span class='fileStatus renamedFileStatus'>Renamed</span><div id='spacer'>&nbsp;</div></td></tr>");
		n.push("<tr><td><ul class='fileStatusList'>")
		for(i;i<l;i++)
		{
			//title='go to " + obj.file +"'
			obj=commitDetailFiles['renamed'][i];
			if(!obj.binary) n.push("<li><span class='renameFrom'>"+obj.from+"</span> -> "+obj.to +"</li>");
			else n.push("<li><span class='renameFrom'>"+obj.from+"</span> -> "+obj.to +" (binary)</li>");
		}
		n.push("</ul></td></tr></table>");
		$("#fileStatusesContainer").append(n.join(""));
	}
	if(commitDetailFiles['changed'].length>0)
	{
		i=0;
		n=[];
		l=commitDetailFiles['changed'].length;
		n.push("<table id='fileStatuses' class='monaco'><tr><td><span class='fileStatus changedFileStatus'>Modified</span><div id='spacer'>&nbsp;</div></td></tr>");
		n.push("<tr><td><ul class='fileStatusList'>")
		for(i;i<l;i++)
		{
			obj=commitDetailFiles['changed'][i];
			if(!obj.binary) n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"' class='file'>"+ obj.file +"</a></li>");
			else n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"' class='file'>"+ obj.file +"</a> (binary)</li>");
		}
		n.push("</ul></td></tr></table>");
		$("#fileStatusesContainer").append(n.join(""));
	}
	if(commitDetailFiles['removed'].length>0)
	{
		i=0;
		n=[];
		l=commitDetailFiles['removed'].length;
		n.push("<table id='fileStatuses' class='monaco'><tr><td><span class='fileStatus removedFileStatus'>Removed</span><div id='spacer'>&nbsp;</div></td></tr>");
		n.push("<tr><td><ul class='fileStatusList'>")
		for(i;i<l;i++)
		{
			obj=commitDetailFiles['removed'][i];
			if(!obj.binary) n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"'>"+ obj.file +"</a></li>");
			else n.push("<li><a href='#"+obj.linkCount+"' title='go to " + obj.file +"'>"+ obj.file +"</a> (binary)</li>");
		}
		n.push("</ul></td></tr></table>");
		$("#fileStatusesContainer").append(n.join(""));
	}
}

function addCommitter()
{
	if(commitDetails.author == commitDetails.committer) return;
	if(commitDetails.committerEmail) commitDetailsTableContent.push("<tr><td class='detailItemLabel' style='width:79px;'>Committer:</td><td class='detailItem'>"+commitDetails.committer+" &lt;<a href='mailto:"+commitDetails.committerEmail+"'>"+commitDetails.committerEmail+"</a>&gt;</td></tr>");
	else commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Committer:</td><td class='detailItem'>"+commitDetails.committer+"</td></tr>");
}

function addAuthorImage()
{
    var userPic = "http://www.gravatar.com/avatar/" + MD5(commitDetails.committerEmail) + "?s=70&d=http%3A%2F%2Fredf.net%2Fgity%2Favatar.jpg";
    if(!commitDetails.authorEmail)
        userPic = "http://www.redf.net/gity/avatar.jpg";
    commitDetailsTableContent.push("<div id='authorImage' style='text-align:left;position:absolute;top:31px;left:10px;width:70px;height:70px;'><img id='gravatarPic' style='-webkit-border-radius:8px;' src='"+userPic+"' altimg='"+userPic+"' width='70px' height='70px'></div>");
}

function addAuthor()
{
	if(commitDetails.authorEmail)
    {
        commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Author:</td><td class='detailItem'>"+commitDetails.author+" &lt;<a href='mailto:"+commitDetails.authorEmail+"'>"+commitDetails.authorEmail+"</a>&gt;</td></tr>");
    }
	else 
        commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Author:</td><td class='detailItem'>"+commitDetails.author+"</td></tr>");
}

function addDate()
{
	//default date.toString() Friday February 13th 2009, 00:27:23pm (GMT-0800 PST)
	//mine: Friday February 13th 2009 @ 12:27:23am (GMT-0800 PST)
	var ds=commitDetails.date.format("ddd mmmm dS yyyy @ hh:MM:sstt ('GMT'o Z)");
	commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Date:</td><td class='detailItem'>"+ ds +"</td></tr>");
}

function addSubject()
{
	if(!commitDetails.subject) return;
	commitDetailsTableContent.push("<tr><td class='detailItemLabel' valign='top'>Subject:</td><td class='detailItem subjectItem'><b>"+commitDetails.subject+"</b></td></tr>");
}

function clearExtendedMessage()
{
	$("#extendedMessageContainer").html("");
}

function addRawMessage()
{
	if(!commitDetails.rawMessage)
	{
		clearExtendedMessage();
		return;
	}
	if(commitDetails.rawMessage.trim() == commitDetails.subject.trim())
	{
		clearExtendedMessage();
		return;
	}
	var raw=commitDetails.rawMessage;
	//raw=raw.replace(/^    /gm, "");
	raw=raw.replace(/\n/gm,"<br/>");
	commitRawMessageDiv.append(raw);
}

function addSHA()
{
	if(!commitDetails.sha) return;
	commitDetailsTableContent.push("<tr><td class='detailItemLabel'>SHA:</td><td class='detailItem'>" + commitDetails.sha);
	commitDetailsTableContent.push(" <a href='javascript:exportTar();' class='archive' title='Export a tar of this commit'>tar</a> ");
	commitDetailsTableContent.push(" <a href='javascript:exportZip();' class='archive' title='Export a zip of this commit'>zip</a> <a href='javascript:newTag");
 	commitDetailsTableContent.push("(\""+commitDetails.fullSHA+"\")' class='archive' title='Tag this commit'>+tag</a> ");
 	if(window.historyDetailsView && !window.historyDetailsView.isHeadDetatched() && commitDetails.parents && commitDetails.parents.length < 2) {
 		commitDetailsTableContent.push("<a href='javascript:cherryPick(\""+commitDetails.fullSHA+"\")' class='archive' title='Cherry pick this commit'>+cherry</a>" );
 	}
 	commitDetailsTableContent.push("</td></tr>" );
}

function addOptions()
{
	return;
	if(!commitDetails.sha) return;
	commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Options:</td><td class='detailItem'>");
	commitDetailsTableContent.push(" <a href='javascript:exportTar();' class='archive' title='Export a tar of this commit'>tar</a> ");
	commitDetailsTableContent.push("<a href='javascript:exportZip();' class='archive' title='Export a zip of this commit'>zip</a> <a href='javascript:newTag");
	commitDetailsTableContent.push("(\""+commitDetails.fullSHA+"\")' class='archive' title='Tag this commit'>+tag</a> ");
	if(window.historyDetailsView && !window.historyDetailsView.isHeadDetatched() && commitDetails.parents && commitDetails.parents.length < 2) {
		commitDetailsTableContent.push("<a href='javascript:cherryPick(\""+commitDetails.fullSHA+"\")' class='archive' title='Cherry pick this commit'>+cherry</a>" );
	}
	commitDetailsTableContent.push("</td></tr>" );
}

function addDiff()
{
	return;
	commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Differ:</td><td class='detailItem'>");
	commitDetailsTableContent.push("<a href='javascript:loadLeft()' class='archive' title='Load this in the left slot of the diff viewer'>left</a> ");
	commitDetailsTableContent.push("<a href='javascript:loadRight()' class='archive'>right</a> </td></tr>");
}

function addTree()
{
	//if(!commitDetails.tree)
	var tree=commitDetails.tree;
	var stree=tree.substring(0,10);
	commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Tree:</td><td class='detailItem'><a href='javascript:loadTree(\""+tree+"\")' title='Inspect this tree'>"+stree+"</a></td></tr>");
}

function addRefs()
{
	if(!window.historyDetailsView) return;
	refs=window.historyDetailsView.getRefs_(commitDetails.fullSHA);
	if(!refs || refs.length < 1) return;
	con=[];
	con.push("<tr><td class='detailItemLabel'>Refs: </td>");
	con.push("<td class='detailItem'>");
	var i=0;
	var l=refs.length;
	for(i;i<l;i++) {
		con.push("<span class='ref'>" + refs[i] + "</span> ");
		//if(i == l-1) con.push("<span class='ref'>" + refs[i] + "</span> ");
		//else con.push("<span class='ref'>" + refs[i] + ",</span> ");
	}
	con.push("</td>");
	commitDetailsTableContent.push(con.join(""));
}

function addParents()
{
	var parent;
	var smallparent;
	var parents=commitDetails.parents;
	var i=0;
	var l=parents.length;
	if(l < 1) return;
	for(i;i<l;i++)
	{
		parent=parents[i];
		smallparent=parent.substring(0,10);
		commitDetailsTableContent.push("<tr><td class='detailItemLabel'>Parent:</td><td class='detailItem'><a href='javascript:loadParent(\"" + parent+ "\")' title='Load this parent commit'>"+smallparent+"</a></td></tr>");
	}
}

function highlightDiffs()
{
	var diff=$("#updateddiff")[0];
	var content=diff.innerHTML.replace(/\t/g, "  ");
	lines=content.split('\n');
	var line1="";
	var line2="";
	var diffContent="";
	var hunk_start_line_1=-1;
	var hunk_start_line_2=-1;
	var firstHunkHeader=true;
	var firstFileLine=true;
	var wasNewBinary=false;
	var wasDeletedBinary=false;
	var header=false;
	k=lines.length;
	for(i;i<k;i++)
	{
		//if(isLineIsAllSpaces())continue;
		l=lines[i];
		var firstChar=l.charAt(0);
		var firstWord=l.match("^[a-zA-Z0-9_]*")[0].toLowerCase();
		if(firstChar=="\\")continue;
		try{nl=lines[i+1];}catch(e){nl=null}
		try{nnl=lines[i+2];}catch(e){nnl=null}
		try{nnnl=lines[i+3];}catch(e){nnnl=null}
		//if(l.match("^\\ No newline at end")) continue;
		if(header) 
		{
			if(firstChar=="+"||firstChar=="-")
			{
				//if we're in the header, and the next line is the start of another diff there's not content.
				//the "nl==''" is for the case where there is no more content, so the diff is complete but with not content.
				if(nl.match("^diff --") || nl=="") diffContent+='<div class="line binaryChange">No diff content</div>';
				continue;
			}
		}
		if(firstWord == "index") continue;
		if(header&&firstWord=="binary")
		{
			msg=l
			m=l.match("Binary files a/(.*) and")
			if(m.length==2) msg = msg = "Binary file " + m[1] + " has changed"
			diffContent += '<div class="line binaryChange">'+msg+'</div>';
			header=false;
			continue;
		}
		
		if(wasNewBinary)
		{
			diffContent+='<div class="line binaryChange">New binary file</div>';
			wasNewBinary=false;
			continue;
		}
		
		if(wasDeletedBinary)
		{
			diffContent+='<div class="line binaryChange">Deleted binary file</div>';
			wasDeletedBinary=false;
			continue;
		}
		
		if(firstWord=="diff")
		{
			header=true;
			var cont;
			var newfile=false;
			var deletedfile=false;
			var deletedbinary=false;
			var binary=false;
			var newbinary=false;
			var isRename=false;
			l=l.replace("--cc ","")
			l=l.replace("--c","")
			if(isRenamedFile()) isRename=true;
			if(isNextLineNewFile()) newfile=true;
			if(isThisFileBinary()) binary=true;
			if(isNextLineDeletedFile()) deletedfile=true;
			if(isNewBinaryFile())
			{
				wasNewBinary=true;
				if(deletedfile)
				{
					deletedbinary=true;
					deletedfile=false;
					wasDeletedBinary=true;
					wasNewBinary=false;
				}
				header=false;
				newbinary=true;
			}
			if(l.match("b/")) pieces=l.split("b/");
			else pieces=l.split(" ");
			file=pieces[pieces.length-1];
			//file=file.replace("b/","");
			firstHunkHeader=true;
			linkCount++;
			if(isCommitDetails)
			{
				var obj={};
				obj.file=file;
				obj.linkCount=linkCount;
				if(isRename)
				{
					var fm=nnl.match("^rename from (t\/)?(.*)");
					var tm=nnnl.match("^rename to (t\/)?(.*)");
					obj.from=fm[2];
					obj.to=tm[2];
					commitDetailFiles['renamed'].push(obj);
					continue;
				}
				if(binary || deletedbinary || newbinary) obj.binary=true;
				if(deletedbinary || deletedfile) commitDetailFiles['removed'].push(obj);
				else if(newbinary || newfile) commitDetailFiles['new'].push(obj);
				else commitDetailFiles['changed'].push(obj);
				if(deletedbinary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(deletedbinary) cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(deletedfile && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' (deleted file) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(deletedfile) cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' (deleted file) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(newbinary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(newbinary) cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(binary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(binary) cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' (binary) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(newfile && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' (new file) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(newfile) cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' (new file) <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else if(firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader"><a name="'+linkCount+'"></a>'+file+' | <a href="#index" class="index" title="Go back to the top">index</a></div>';
				else cont='<div class="fileHeader"><a name="'+linkCount+'"></a>'+file+' | <a href="#index" class="index" title="Go back to the top">index</a></div>';
			}
			else
			{
				if(deletedbinary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+' (binary)</div>';
				else if(deletedbinary) cont='<div class="fileHeader">'+file+' (binary)</div>';
				else if(deletedfile && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+' (deleted file)</div>';
				else if(deletedfile) cont='<div class="fileHeader">'+file+' (deleted file)</div>';
				else if(newbinary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+' (binary)</div>';
				else if(newbinary) cont='<div class="fileHeader">'+file+' (binary)</div>';
				else if(binary && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+' (binary)</div>';
				else if(binary) cont='<div class="fileHeader">'+file+' (binary)</div>';
				else if(newfile && firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+' (new file)</div>';
				else if(newfile) cont='<div class="fileHeader">'+file+' (new file)</div>';
				else if(firstFileLine && !isCommitDetails) cont='<div class="firstFileHeader">'+file+'</div>';
				else cont='<div class="fileHeader">'+file+'</div>';
			}
			diffContent+=cont
			if(((newbinary || newfile) || (deletedbinary||deletedfile)) && isFileNoContent())
			{
				diffContent+='<div class="line binaryChange">Empty file</div>';
			}
			firstFileLine=false;
			line1+='\n';
			line2+='\n';
			continue;
		}
		
		if(isLineTooLong())
		{
			if(firstChar=="+")
			{
				diffContent+="<div class='longline line'>+ This line is too long to display. Lines cannot exceed 24,500 characters.</div>";
				line1+="\n";
				line2+=++hunk_start_line_2+"\n";
			}
			else if(firstChar=="-")
			{
				diffContent+="<div class='longline line'>- This line is too long to display. Lines cannot exceed 24,500 characters.</div>";
				line1+=++hunk_start_line_1+"\n";
				line2+="\n";
			}
			else
			{
				diffContent+="<div class='longline line'> This line is too long to display. Lines cannot exceed 24,500 characters.</div>";
				line1+="\n";
				line2+="\n";
			}
		}
		else if(firstChar=="+")
		{
			//if(m=l.match(/\s+$/)) l=l.replace(/\s+$/,"<span class='addedWhitespace line'>"+m+"</span>"); //highlight trailing whitespace
			diffContent+="<div class='addline line'>"+l+"</div>";
			line1+="\n";
			line2+=++hunk_start_line_2+"\n";
		}
		else if(firstChar=="-")
		{
			//if(m=l.match(/\s+$/)) l=l.replace(/\s+$/,"<span class='removedWhitespace line'>"+m+"</span>");
			diffContent+="<div class='delline line'>"+l+"</div>";
			line1+=++hunk_start_line_1+"\n";
			line2+="\n";
		}
		else if(firstChar=="@")
		{
			//if(line1 != "") alert(line1);
			//if(line2 != "") alert(line2);
			line1="";
			line2="";
			if(m=l.match(/@@ \-([0-9]+),\d+ \+(\d+),\d+ @@/))
			{
				hunk_start_line_1=parseInt(m[1])-1;
				hunk_start_line_2=parseInt(m[2])-1;
			}
			l=l.replace(/@ ?/g,"");
			if(firstHunkHeader) diffContent+="<div class='firsthunkheader'>"+l+"</div>";
			else diffContent+="<div class='hunkheader'>"+l+"</div>";
			firstHunkHeader=false;
			header=false;
			line1+="\n";
			line2+="\n";
			if(nextLineIsAllSpaces())
			{
				i+=1;
				continue;
			}
		}
		else if(firstChar==" ")
		{
			//if(m=l.match(/\s+$/)) l=l.replace(/\s+$/,"<span class='removedWhitespace line'>"+m+"</span>");
			diffContent += "<span class='line'>"+l+"</span>\n";
			line1+=++hunk_start_line_1 + "\n";
			line2+=++hunk_start_line_2 + "\n";
		}
	}
	diff.innerHTML="<table width='100%'><td><pre>" + diffContent + "</pre></td></tr></table>";
}

/** utilities **/

/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */
var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	"default":"ddd mmm dd yyyy HH:MM:ss",
	shortDate:"m/d/yy",
	mediumDate:"mmm d, yyyy",
	longDate:"mmmm d, yyyy",
	fullDate:"dddd, mmmm d, yyyy",
	shortTime:"h:MM TT",
	mediumTime:"h:MM:ss TT",
	longTime:"h:MM:ss TT Z",
	isoDate:"yyyy-mm-dd",
	isoTime:"HH:MM:ss",
	isoDateTime:"yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime:"UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format=function(mask,utc){return dateFormat(this, mask, utc);};

String.prototype.trim = function() {return this.replace(/^\s+|\s+$/g,"");}
String.prototype.ltrim = function() {return this.replace(/^\s+/,"");}
String.prototype.rtrim = function() {return this.replace(/\s+$/,"");}
