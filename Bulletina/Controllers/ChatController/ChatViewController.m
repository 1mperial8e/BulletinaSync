//
//  ChatTableViewController.m
//  Bulletina
//
//  Created by Stas Volskyi on 1/22/16.
//  Copyright © 2016 AppMedia. All rights reserved.
//

//Controllers
#import "ChatViewController.h"

//Cells
#import "MessageTableViewCell.h"
#import "PostTableViewCell.h"

static NSString *const ViewControllerTitle = @"Chat";
static NSString *const MessageTextViewPlaceholder = @"Your message";

static CGFloat const DefaultTableViewSectionsCount = 2;
static CGFloat const DefaultMessageTextViewHeight = 30.f;
static CGFloat const DefaultRowHeight = 65.f;

typedef NS_ENUM(NSUInteger, SectionType){
    SectionPost,
    SectionMessages
};

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIView *messageInputView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageTextViewConstraint;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ChatViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareUI];
    [self registerNibs];
    [self prepareDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIResponder

- (UIView *)inputAccessoryView
{
    return self.messageInputView;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return DefaultTableViewSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //TODO: delete hardcode
    return section == SectionMessages ? self.dataSource.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.section == SectionMessages) {
        cell = [[MessageTableViewCell alloc] initCellWithReuseIdentifier:MessageTableViewCell.ID];
        [self configureMessageCell:(MessageTableViewCell *)cell forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:PostTableViewCell.ID forIndexPath:indexPath];
        [self configureCell:(PostTableViewCell *)cell forIndexPath:indexPath];
    }

    return cell;
}

- (void)configureMessageCell:(MessageTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    NSInteger type = indexPath.row % 2 ? MessageTypeOutgoing : MessageTypeIncoming;
    [cell configureCellWithMessageType:type];
}

- (void)configureCell:(PostTableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath
{
    //TODO: configure cell
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionPost) {
        return DefaultRowHeight;
    } else {
        //TODO: configure message cell, calculate cell height, delete hardcoded height
        
        return 120.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SectionPost) {
          //TODO: tap on first section cells
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self scrollTableViewToBottom];
    
    if ([textView.text isEqualToString:MessageTextViewPlaceholder]) {
        textView.text = nil;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self pressSendButton];
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self adjustMessageTextViewFrame];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (!textView.text.length) {
        textView.text = MessageTextViewPlaceholder;
    }
}

#pragma mark - Private Methods

- (void)prepareUI
{
    [self prepareNavigationBar];
    self.title = ViewControllerTitle;
    self.view.backgroundColor = [UIColor mainPageBGColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)prepareNavigationBar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)registerNibs
{
    [self.tableView registerNib:PostTableViewCell.nib forCellReuseIdentifier:PostTableViewCell.ID];
}

- (void)prepareDataSource
{
    //TODO: remove hardcoded data source
    
    self.dataSource = @[@1, @1, @1, @1, @1, @1, @1, @1, @1, @1].mutableCopy;
    [self.tableView reloadData];
}

- (void)scrollTableViewToBottom
{
    //TODO: scroll to bottom
}

- (void)adjustMessageTextViewFrame
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat textViewMinY =  CGRectGetMinY([self.view convertRect:self.messageTextView.superview.frame toView:window]);
    CGFloat tableViewMinY = CGRectGetMinY([self.tableView convertRect:self.tableView.frame toView:window]);
    
    //TODO: cutting Message View issue
    if (textViewMinY <= tableViewMinY) {
        return;
    }
    
    CGFloat contentHeight = self.messageTextView.contentSize.height;

    self.messageTextViewConstraint.constant = contentHeight < DefaultMessageTextViewHeight ? DefaultMessageTextViewHeight : contentHeight;
    [self.messageTextView layoutIfNeeded];
}

- (void)pressSendButton
{
    self.messageTextView.text = MessageTextViewPlaceholder;
    [self.view endEditing:YES];
    [self adjustMessageTextViewFrame];
    [self scrollTableViewToBottom];
    
    //TODO: send button tap handler
}

#pragma mark - NSNotification

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = keyboardFrame.size.height - self.tabBarController.tabBar.frame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}

@end
