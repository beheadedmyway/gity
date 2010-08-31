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

#import "GTOpLoadHistory.h"

#include <ext/stdio_filebuf.h>
#include <iostream>
#include <string>
#include <map>
using namespace std;

@implementation GTOpLoadHistory

- (id) initWithGD:(GittyDocument *) _gd andLoadInfo:(GTGitCommitLoadInfo *) _loadInfo andCallback:(GTCallback *) _callback {
	callback=[_callback retain];
	loadInfo=[_loadInfo retain];
	commits=[[NSMutableArray alloc] init];
	self=[super initWithGD:_gd];
	return self;
}

- (id) initWithGD:(GittyDocument *) _gd andLoadInfo:(GTGitCommitLoadInfo *) _loadInfo {
	loadInfo=[_loadInfo retain];
	stoutEncoding=NSASCIIStringEncoding;
	commits=[[NSMutableArray alloc] init];
	useCPP=true;
	usec=false;
	self=[super initWithGD:_gd];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	readsSTDOUT=true;
	[args addObject:@"log"];
	if([loadInfo refName]) [args addObject:[loadInfo refName]];
	NSString * formatString;
	if(useCPP) {
		[args addObject:@"-z"];
		formatString = @"--pretty=format:%e\01%h\01%H\01%an\01%s\01%at";
	} else {
		formatString = @"--pretty=format:%e:gt:%h:gt:%H:gt:%P:gt:%an:gt:%s:gt:%at";
	}
	[args addObject:@"--topo-order"];
	
	//BOOL showSign = [rev hasLeftRight];
	//if(showSign) formatString = [formatString stringByAppendingString:@"\01%m"];
	[args addObject:formatString];
	
	//if([loadInfo after]) [args addObject:[@"--after=" stringByAppendingString:[loadInfo afterDateAsTimeIntervalString]]];
	//if([loadInfo before]) [args addObject:[@"--before=" stringByAppendingString:[loadInfo beforeDateAsTimeIntervalString]]];
	//if([loadInfo authorContains]) [args addObject:[@"--author=" stringByAppendingString:[loadInfo authorContains]]];
	[self updateArguments];
}

- (void) readSTDOUT {
	if(usec) [self readSTDOUTC];
	else if(useCPP) [self readSTDOUTCPP];
	else [super readSTDOUT];
}

- (void) readSTDOUTC {
	int c;
	NSData * data = [stout dataUsingEncoding:NSUTF8StringEncoding];
	char * bytes = (char *)[data bytes];
	//unsigned char linec;
	char line_buf[2048]; //2MB buffer
	char * bufp = line_buf;
	//NSMutableArray * lines = [[NSMutableArray alloc] init];
	NSString * line, *encoding, *author, *subject, *sha, *asha;
	NSArray * pieces, * parents;
	NSDate * date;
	GTGitCommit * commit;
	while((c = *bytes++)) {
		if(c == EOF) break;
		if(c == '\n') {
			*bufp = '\0';
			//[lines addObject:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]];
			//now we've got a full line in the line_buf;
			/*
			bufp=line_buf;
			while(linec = *bufp++) {
			if(mag == ":gt:") {
			}
			}
			*/
			commit = [[GTGitCommit alloc] init];
			line = [NSString stringWithCString:line_buf encoding:NSUTF8StringEncoding];
			pieces = [line componentsSeparatedByString:@":gt:"];
			encoding = [pieces objectAtIndex:0];
			asha = [pieces objectAtIndex:1];
			sha = [pieces objectAtIndex:2];
			parents = [[pieces objectAtIndex:3] componentsSeparatedByString:@" "];
			author = [pieces objectAtIndex:4];
			subject = [pieces objectAtIndex:5];
			date = [NSDate dateWithTimeIntervalSince1970:[[pieces objectAtIndex:6] doubleValue]];
			[commit setAbbrevHash:asha];
			[commit setHash:sha];
			[commit setParents:parents];
			[commit setAuthor:author];
			[commit setSubject:subject];
			[commit setDate:date];
			[commits addObject:commit];
			[commit release];
		}
		*bufp++=c;
	}
}

- (void) readSTDOUTCPP {
	NSFileHandle * handle = [[task standardOutput] fileHandleForReading];
	NSStringEncoding encoding = NSUTF8StringEncoding;
	std::map<string, NSStringEncoding> encodingMap;
	int fd = [handle fileDescriptor];
	__gnu_cxx::stdio_filebuf<char> buf(fd, std::ios::in);
	std::istream stream(&buf);
	while(true) {
		char c;
		int time;
		string encoding_str,sha,shortSha,author,subject,parentString;
		getline(stream,encoding_str,'\1');
		if(encoding_str.length()) {
			if(encodingMap.find(encoding_str) != encodingMap.end()) {
				encoding = encodingMap[encoding_str];
			} else {
				encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[NSString stringWithUTF8String:encoding_str.c_str()]));
				encodingMap[encoding_str] = encoding;
			}
		}
		
		if(!getline(stream,shortSha,'\1')) break;
		if(!getline(stream,sha,'\1')) break;
		
		//if(sha[1]=='i') { // Matches 'Final output'
		//	num=0;
		//[self performSelectorOnMainThread:@selector(setCommits:) withObject:revisions waitUntilDone:NO];
		//g=[[PBGitGrapher alloc] initWithRepository: repository];
		//revisions = [NSMutableArray array];
		// If the length is < 40, then there are no commits.. quit now
		//	if(sha.length() < 40) break;
		//	sha=sha.substr(sha.length()-40,40);
		//}
		
		//getline(stream, parentString, '\1');
		//if(parentString.size() != 0)
		//{
		//	if(((parentString.size() + 1) % 41) != 0) continue;
		//	int nParents = (parentString.size() + 1) / 41;
		//	git_oid *parents = (git_oid *)malloc(sizeof(git_oid) * nParents);
		//	int parentIndex;
		//	for (parentIndex = 0; parentIndex < nParents; ++parentIndex)
		//		git_oid_mkstr(parents + parentIndex, parentString.substr(parentIndex * 41, 40).c_str());
		//	
		//	newCommit.parentShas = parents;
		//	newCommit.nParents = nParents;
		//}
		
		getline(stream,author,'\1');
		getline(stream,subject,'\1');
		stream >> time;
		
		NSString * shaw = [NSString stringWithCString:sha.c_str() encoding:encoding];
		NSString * abbrevSha = [NSString stringWithCString:shortSha.c_str() encoding:encoding];
		
		//if(showSign) {
		//	char c;
		//	stream >> c; // Remove separator
		//	stream >> c;
		//	if (c != '>' && c != '<' && c != '^' && c != '-')
		//		NSLog(@"Error loading commits: sign not correct");
		//	[newCommit setSign: c];
		//}
		
		stream >> c;
		//if(c!='\0') cout << "Error" << endl;
		
		//continue;
		
		GTGitCommit * commit = [[GTGitCommit alloc] init];
		[commit setHash:shaw];
		[commit setAbbrevHash:abbrevSha];
		[commit setSubject:[NSString stringWithCString:subject.c_str() encoding:encoding]];
		[commit setAuthor:[NSString stringWithCString:author.c_str() encoding:encoding]];
		[commit setDate:[NSDate dateWithTimeIntervalSince1970:time]];
		[commits addObject:commit];
		[commit release];
	}
	[handle closeFile];
}

- (void) taskComplete {
	if(useCPP || usec) {
		done=true;
		[gitd setHistoryCommits:commits];
		return;
	}
	GTGitCommit * commit;
	NSArray * info, * aparents;
	NSString *line, *parents, *encoding,  *time, *author;
	NSArray * lines = [stout componentsSeparatedByString:@"\n"];
	NSDate * commitDate;
	NSStringEncoding commitEncoding = NSUTF8StringEncoding;
	for(line in lines) {
		commit = [[GTGitCommit alloc] init];
		info = [line componentsSeparatedByString:@":gt:"];
		encoding=[info objectAtIndex:0];
		if(encoding) commitEncoding=CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)encoding));
		
		[commit setAbbrevHash:[info objectAtIndex:1]];
		[commit setHash:[info objectAtIndex:2]];
		[commit setSubject:[info objectAtIndex:5]];
		
		parents = [info objectAtIndex:3];
		aparents = [parents componentsSeparatedByString:@" "];
		[commit setParents:aparents];
		
		NSString * a = [info objectAtIndex:4];
		author = [NSString stringWithCString:[a UTF8String] encoding:commitEncoding];
		[commit setAuthor:[info objectAtIndex:4]];
		
		time = [info objectAtIndex:6];
		commitDate = [NSDate dateWithTimeIntervalSince1970:[time doubleValue]];
		[commit setDate:commitDate];
		
		[commits addObject:commit];
		[commit release];
		commit = nil;
	}
	done=true;
	[gitd setHistoryCommits:commits];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpLoadHistory\n");
	#endif
	GDRelease(callback);
	GDRelease(loadInfo);
	GDRelease(commits);
	[super dealloc];
}

@end
