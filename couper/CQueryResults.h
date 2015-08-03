//
//  CQueryResults.h
//  Couper
//
//  Created by Vinay on 3/29/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQueryResults : NSObject{
    
}

@property(nonatomic, retain) NSMutableArray* array;


-(id) initWithArray:(NSMutableArray *)arr resultsType:(Class)classType;


@end
