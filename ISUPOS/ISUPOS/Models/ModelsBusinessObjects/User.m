//
//  User.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic created_date;
@dynamic email;
@dynamic first_name;
@dynamic is_active;
@dynamic is_deleted;
@dynamic last_name;
@dynamic modified_date;
@dynamic password;
@dynamic user_id;
@dynamic user_type;
@dynamic username;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self asignProperties];
    }
    return self;
}

-(void)asignProperties
{
    self.created_date = [NSDate date];
    self.email = @"";
    self.first_name = @"";
    self.is_active = [NSNumber numberWithBool:YES];
    self.is_deleted = [NSNumber numberWithBool:NO];
    self.last_name = @"";
    self.modified_date = [NSDate date];
    self.password = @"";
    self.user_id = [NSNumber numberWithInt:0];
    self.user_type = [NSNumber numberWithInt:0];
    self.username =  @"";
}

+(User*)getInstanceForInsert
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    return  kInsertWithNameAndWithContext(@"User",context);
}

@end
