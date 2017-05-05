//
//  User.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * user_type;
@property (nonatomic, retain) NSString * username;

@end
