//
//  DongliWorkOrderViewController.m
//  i动力
//
//  Created by Bonnie on 16/10/25.
//  Copyright © 2016年 Min.wang. All rights reserved.
//

#import "DongliWorkOrderViewController.h"
#import "UnfinishedViewController.h"
#import "DoingViewController.h"
#import "FinishViewController.h"
#import "AddOrderViewController.h"
#define kSearchTypeStartTag   700
#define kSearchTyepEndTag     702
#define kSearchTypeStroyBoard_unfinish      @"UnfinishedViewController"
#define kSearchTypeStroyBoard_doing         @"DoingViewController"
#define kSearchTypeStroyBoard_finish        @"FinishViewController"
@interface DongliWorkOrderViewController ()
{
    UIViewController *_currentViewController;
    UnfinishedViewController *_unfinishedViewController;
    DoingViewController      *_doingViewController;
    FinishViewController     *_finishViewController;
}
@property (weak, nonatomic) IBOutlet UIView *childView;

@end

@implementation DongliWorkOrderViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleWithPosition:@"left" title:@"动力工单"];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置navigationbar左按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 10, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backActionToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=backBarBtn;
    
    //设置navigationbar右按钮
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(15, 15, 16, 16);
    [right setBackgroundImage:[UIImage imageNamed:@"create"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightITem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem=rightITem;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动力工单";
    self.view.backgroundColor = [UIColor whiteColor];
    

    _currentViewController = kGetViewController(@"DongliWorkOrderStoryboard", kSearchTypeStroyBoard_unfinish);
    [self addChildViewController:_currentViewController];
    _currentViewController.view.frame = self.childView.bounds;
    [self.childView addSubview:_currentViewController.view];
    [_currentViewController didMoveToParentViewController:self];
    UIButton *btn = [self.view viewWithTag:kSearchTypeStartTag];
    btn.selected = YES;
    [self switchButtonAction:btn];
//    [self getDataWithSearhType:kSearchTypeStartTag];

}

-(void)addBtnClick:(UIButton *)sender
{
    AddOrderViewController *add = [[AddOrderViewController alloc] init];
    [self.navigationController pushViewController:add animated:YES];
}

-(void)backActionToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 导航栏5个type切换
- (IBAction)switchButtonAction:(UIButton *)sender {
    for (int index = kSearchTypeStartTag; index < kSearchTyepEndTag + 1; index++) {
        UIButton *btn = [self.view viewWithTag:index];
        btn.selected = NO;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    [sender setTitleColor:kColor_blue forState:UIControlStateSelected];
    sender.selected = YES;
    
    
    [self getDataWithSearhType:sender.tag];
    
}

#pragma mark --- get data
-(void)getDataWithSearhType:(NSInteger)type
{
    //    [[SXMRequestController shareController] searchWithType:type keyword:_searchTXT pageNumber:1 pageSize:10 handler:^(id response, SXMError *error) {
    //        _searchResultListData = (SXMSearchResultListData *)response;
    switch (type) {
        case 700:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_unfinishedViewController) {
                    _unfinishedViewController = kGetViewController(@"DongliWorkOrderStoryboard", kSearchTypeStroyBoard_unfinish);
                }
                [self replaceController:_currentViewController toController:_unfinishedViewController];
            });
        }
            break;
        case 701:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_doingViewController) {
                    _doingViewController = kGetViewController(@"DongliWorkOrderStoryboard",kSearchTypeStroyBoard_doing);
                }
                [self replaceController:_currentViewController toController:_doingViewController];
            });
        }
            break;
        case 702:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!_finishViewController) {
                    _finishViewController = kGetViewController(@"DongliWorkOrderStoryboard", kSearchTypeStroyBoard_finish);
                }
                [self replaceController:_currentViewController toController:_finishViewController];
            });
        }
            break;
            
    }
    
    //     }];
}

- (void)replaceController:(UIViewController *)oldController toController:(UIViewController *)toController
{
    [self addChildViewController:toController];
    [oldController willMoveToParentViewController:nil];
    
    [self transitionFromViewController:oldController toViewController:toController duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [toController didMoveToParentViewController:self];
            [oldController removeFromParentViewController];
            
            _currentViewController = toController;
            _currentViewController.view.frame = self.childView.bounds;
            
        }else{
            _currentViewController = oldController;
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
