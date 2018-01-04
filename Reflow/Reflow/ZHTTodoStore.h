//
//  ZHTStore.h
//  Reflow
//
//  Created by 赵海亭 on 2018/1/4.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

#import "RFStore.h"

typedef NS_ENUM(NSInteger, VisibilityFilter) {
    VisibilityFilterShowAll,
    VisibilityFilterShowActive,
    VisibilityFilterShowCompleted,
};

@interface ZHTTodoStore : RFStore

#pragma mark - Getters

- (NSArray *)visibleTodos;
- (VisibilityFilter)visibilityFilter;

#pragma mark - Actions

- (void)actionAddTodo:(NSString *)text;
- (void)actionToggleTodo:(NSInteger)todoId;

- (void)actionSetVisibilityFilter:(VisibilityFilter)filter;

@end
