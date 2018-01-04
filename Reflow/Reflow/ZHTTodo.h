//
//  ZHTTodo.h
//  Reflow
//
//  Created by 赵海亭 on 2018/1/4.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHTTodo : NSObject

@property (nonatomic, assign) NSInteger todoId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL completed;

@end
