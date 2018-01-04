//
//  ZHTTodoTableViewController.m
//  Reflow
//
//  Created by 赵海亭 on 2018/1/4.
//  Copyright © 2018年 赵海亭. All rights reserved.
//

#import "ZHTTodoTableViewController.h"
#import "ZHTTodo.h"
#import "ZHTTodoStore.h"

@interface ZHTTodoTableViewController ()

/** todo */
@property (nonatomic, strong) ZHTTodoStore *todoStore;
@property (nonatomic, strong) NSArray *todos;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filterButton;

@property (nonatomic, strong) RFSubscription *subscription;

@end

@implementation ZHTTodoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.todoStore = [[ZHTTodoStore alloc] init];
    self.todos = self.todoStore.visibleTodos;
    
     __weak typeof(self) weakSelf = self;
    self.subscription = [self.todoStore subscribe:^(RFAction *action) {
        __strong typeof(self) strongSelf = weakSelf;
        if (action.selector == @selector(actionSetVisibilityFilter:)) {
            strongSelf.filterButton.title = [strongSelf stringFromVisibilityFilter:[strongSelf.todoStore visibilityFilter]];
        }
        strongSelf.todos = [strongSelf.todoStore visibleTodos];
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - private method

- (NSString *)stringFromVisibilityFilter:(VisibilityFilter)filter {
    switch (filter) {
        case VisibilityFilterShowAll:
            return @"All";
            break;
        case VisibilityFilterShowActive:
            return @"Active";
            break;
        case VisibilityFilterShowCompleted:
            return @"Completed";
            break;
        default:
            NSAssert(NO, @"Unknown filter:%ld", (long)filter);
            return nil;
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.todos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    ZHTTodo *todo = [self.todos objectAtIndex:indexPath.row];
    cell.textLabel.text = todo.text;
    cell.accessoryType = todo.completed ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view dalegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZHTTodo *todo = [self.todos objectAtIndex:indexPath.row];
    [self.todoStore actionToggleTodo:todo.todoId];
}


#pragma mark - event response

- (IBAction)changeFilter:(id)sender {
    
    VisibilityFilter filter = [self.todoStore visibilityFilter];
    switch (filter) {
        case VisibilityFilterShowAll:
            [self.todoStore actionSetVisibilityFilter:VisibilityFilterShowActive];
            break;
        case VisibilityFilterShowActive:
            [self.todoStore actionSetVisibilityFilter:VisibilityFilterShowCompleted];
            break;
        case VisibilityFilterShowCompleted:
            [self.todoStore actionSetVisibilityFilter:VisibilityFilterShowAll];
            break;
        default:
            NSAssert(NO, @"Unknown filter:%ld", (long)filter);
            break;
    }
    
}
- (IBAction)addTodo:(id)sender {
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"Add Todo" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertCon addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"New todo";
    }];
    
    __weak UIAlertController *weakAlert = alertCon;
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong UIAlertController *strongAlert = weakAlert;
        UITextField *textfield = strongAlert.textFields.firstObject;
        [self.todoStore actionAddTodo:textfield.text];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alertCon addAction:sure];
    [alertCon addAction:cancel];
    
    [self presentViewController:alertCon animated:YES completion:^{
        UITextField *textField = alertCon.textFields.firstObject;
        textField.selectedTextRange = [textField textRangeFromPosition:[textField beginningOfDocument] toPosition:[textField endOfDocument]];
    }];
}

@end
