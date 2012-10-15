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

- (id) initWithGD:(GittyDocument *) _gd andLoadInfo:(GTGitCommitLoadInfo *) _loadInfo {
	self=[super initWithGD:_gd];
	loadInfo=[_loadInfo retain];
	stoutEncoding=NSASCIIStringEncoding;
	commits=[[NSMutableArray alloc] init];
	return self;
}

- (void) setArguments {
	if([self isCancelled]) return;
	readsSTDOUT=true;
	[args addObject:@"log"];
	GTGitDataStore *dataStore = [gd gitd];
	if ([loadInfo refName])
	{
		if ([[loadInfo refName] isEqualToString:dataStore.activeBranchName] && dataStore.isHeadDetatched)
			[args addObject:dataStore.currentAbbreviatedSha];
		else
			[args addObject:[loadInfo refName]];
	}
	NSString * formatString;
    [args addObject:@"-z"];
    formatString = @"--pretty=format:\01%e\01%h\01%H\01%an\01%s\01%at";
	[args addObject:@"--topo-order"];
    [args addObject:@"--graph"];
	
	//BOOL showSign = [rev hasLeftRight];
	//if(showSign) formatString = [formatString stringByAppendingString:@"\01%m"];
	[args addObject:formatString];
    
    // safety addition in case there's a filename w/ the same name as the branch.
    [args addObject:@"--"];
	
	//if([loadInfo after]) [args addObject:[@"--after=" stringByAppendingString:[loadInfo afterDateAsTimeIntervalString]]];
	//if([loadInfo before]) [args addObject:[@"--before=" stringByAppendingString:[loadInfo beforeDateAsTimeIntervalString]]];
	//if([loadInfo authorContains]) [args addObject:[@"--author=" stringByAppendingString:[loadInfo authorContains]]];
	[self updateArguments];
}

- (void) readSTDOUT {
	NSFileHandle * handle = [[task standardOutput] fileHandleForReading];
	NSStringEncoding encoding = NSUTF8StringEncoding;
	std::map<string, NSStringEncoding> encodingMap;
	int fd = [handle fileDescriptor];
	__gnu_cxx::stdio_filebuf<char> buf(fd, std::ios::in);
	std::istream stream(&buf);
	while(true) {
		char c;
		int time;
		string encoding_str,sha,shortSha,author,subject,parentString,graphString;
        
        if(!getline(stream,graphString, '\1')) break;

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
		
        //[commit setSubject:[NSString stringWithCString:subject.c_str() encoding:encoding]];
        NSString *subjectString = [NSString stringWithCString:subject.c_str() encoding:encoding];
        NSString *graphicString = [NSString stringWithCString:graphString.c_str() encoding:encoding];
        [commit setSubject:[NSString stringWithFormat:@"%@%@", graphicString, subjectString]];
        
		[commit setAuthor:[NSString stringWithCString:author.c_str() encoding:encoding]];
		[commit setDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [commit setGraph:[NSString stringWithCString:graphString.c_str() encoding:encoding]];
		[commits addObject:commit];
		[commit release];
	}
	[handle closeFile];
}

- (void) taskComplete {
    done=true;
    [gitd setHistoryCommits:commits];
}

- (void) dealloc {
	#ifdef GT_PRINT_DEALLOCS
	printf("DEALLOC GTOpLoadHistory\n");
	#endif
	GDRelease(loadInfo);
	GDRelease(commits);
	[super dealloc];
}

@end
