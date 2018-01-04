//
//  ZHTStore.m
//  Reflow
//
//  Created by 赵海亭 on 2018/1/4.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

#import "ZHTTodoStore.h"
#import "ZHTTodo.h"
#import "NSArray+Functional.h"

@interface ZHTTodoStore ()

@property (nonatomic, strong) NSArray *todos;
@property (nonatomic, assign) VisibilityFilter filter;
@property (nonatomic, assign) NSInteger nextTodoId;

@end

@implementation ZHTTodoStore

- (instancetype)init {
    
    if (self = [super init]) {
        ZHTTodo *todo1 = [[ZHTTodo alloc] init];
        todo1.todoId = ++self.nextTodoId;
        todo1.text = @"hello world";
        todo1.completed = YES;
        
        ZHTTodo *todo2 = [[ZHTTodo alloc] init];
        todo2.todoId = ++self.nextTodoId;
        todo2.text = @"happy new year";
        todo2.completed = NO;
        
        ZHTTodo *todo3 = [[ZHTTodo alloc] init];
        todo3.todoId = ++self.nextTodoId;
        todo3.text = @"i have a pen";
        todo3.completed = NO;
        
        self.todos = @[todo1, todo2, todo3];
    }
    return self;
}

- (NSArray *)visibleTodos {
    
    switch (self.filter) {
        case VisibilityFilterShowAll:
            return self.todos;
            break;
        case VisibilityFilterShowActive:
            return [self.todos filter:^BOOL(ZHTTodo *value) {
                return !value.completed;
            }];
            break;
        case VisibilityFilterShowCompleted:
            return [self.todos filter:^BOOL(ZHTTodo *value) {
                return value.completed;
            }];
            break;
    }
}

- (VisibilityFilter)visibilityFilter {
    
    return self.filter;
}

- (void)actionAddTodo:(NSString *)text {
    
    ZHTTodo *todo = [[ZHTTodo alloc] init];
    todo.todoId = ++self.nextTodoId;
    todo.text = text;
    todo.completed = YES;
    
    self.todos = [self.todos arrayByAddingObject:todo];
}

- (void)actionToggleTodo:(NSInteger)todoId {
    
    self.todos = [self.todos map:^id(ZHTTodo * value) {
        if (value.todoId == todoId) {
            ZHTTodo *newTodo = [[ZHTTodo alloc] init];
            newTodo.todoId = value.todoId;
            newTodo.text = value.text;
            newTodo.completed = !value.completed;
            return newTodo;
        }
        return value;
    }];
}

- (void)actionSetVisibilityFilter:(VisibilityFilter)filter {
    
    self.filter = filter;
}

@end
