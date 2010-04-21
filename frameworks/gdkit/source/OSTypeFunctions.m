//copyright 2009 aaronsmith

OSType fourCharCodeToOSType(NSString* inCode) {
	OSType rval = 0;
	NSData* data = [inCode dataUsingEncoding: NSMacOSRomanStringEncoding];
	[data getBytes:&rval length:sizeof(rval)];
	return rval;
}

NSString * osTypeToFourCharCode(OSType inType) {
	NSData * data = [NSData dataWithBytes:&inType length:sizeof(inType)];
	NSString * ret = [[NSString alloc]initWithData:data encoding:NSMacOSRomanStringEncoding];
  	return [ret autorelease];
}