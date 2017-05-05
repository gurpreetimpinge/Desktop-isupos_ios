/*
	SDZEntityKeyMember.h
	The interface definition of properties and methods for the SDZEntityKeyMember object.
	Generated by SudzC.com
*/

#import "Soap.h";
	

@interface SDZEntityKeyMember : SoapObject
{
	NSString* _Key;
	id _Value;
	
}
		
	@property (retain, nonatomic) NSString* Key;
	@property (retain, nonatomic) id Value;

	+ (SDZEntityKeyMember*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end