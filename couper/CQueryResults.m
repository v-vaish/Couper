//
//  CQueryResults.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import "CQueryResults.h"
#import "NSDictionary+NullValueReplace.h"

@implementation CQueryResults

-(id) initWithArray:(NSMutableArray *)arr resultsType:(Class)classType{
    self = [super init];
    
    if(self){
        if(arr && arr.count){
            
            self.array = [NSMutableArray arrayWithCapacity:[arr count]];
            
            for(int i=0; i<[arr count]; i++){
                id item = [[classType alloc] initWithDictionary:[arr objectAtIndex:i]];
                [self.array addObject:item];
            }
        }
    }
    
    return self;
}



@end
