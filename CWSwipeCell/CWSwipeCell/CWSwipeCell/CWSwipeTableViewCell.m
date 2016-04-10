//
//  CWSwipeTableViewCell.m
//  CWSwipeCell
//
//  Created by Li Chen wei on 2016/4/7.
//  Copyright © 2016年 TWML. All rights reserved.
//

#import "CWSwipeTableViewCell.h"

@interface CWSwipeTableViewCell ()<UIGestureRecognizerDelegate>

@property (nonatomic) BOOL ignoreSwipe;
@property (nonatomic) BOOL startSwipe;
@property (nonatomic) CWTableViewCellStatus actionStatus;

@end

@implementation CWSwipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self initCellSetting];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithTableViewCellType:(CWTableViewCellStyle)style reuseIdentifier:(NSString *)reuseID
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    
    if (self) {
        
        
        [self initCellSetting];
        
        
        
    }
    
    return self;
}

- (void)initCellSetting
{
    _ignoreSwipe = YES;
    _startSwipe = NO;
    
    _cellStatus = CWTableViewCellStatusNormal;
    _actionStatus = CWTableViewCellStatusNormal;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapGestureRecognizer setNumberOfTapsRequired:2];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    tapGestureRecognizer.delegate = self;
    [self addGestureRecognizer:tapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]; // or use Pan
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];


    
}

#pragma mark -

- (void)swipeViewStatue:(CWTableViewCellStatus)cellStatus
{
    
    int _rightView = (_rightSwipeView == nil ? 0 : _rightSwipeView.frame.size.width);
    int _leftView = (_leftSwipeView == nil ? 0 : _leftSwipeView.frame.size.width);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        if (cellStatus == CWTableViewCellStatusOpenRight) {
            [self contentViewMoveWithTargetPoint:_rightView];
        }else if (cellStatus == CWTableViewCellStatusOpenRight) {
            [self contentViewMoveWithTargetPoint:_leftView];
        }else{
            [self contentViewMoveWithTargetPoint:0];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [(UITableView *)self.superview.superview setScrollEnabled:YES];
        }
    }];
    
}

- (void)contentViewMoveWithTargetPoint:(float)point //傳入應該要移動到的位置
{
    int _rightView = (_rightSwipeView == nil ? 0 : _rightSwipeView.frame.size.width);
    int _leftView = (_leftSwipeView == nil ? 0 : _leftSwipeView.frame.size.width);
    
    
    if (point > 0) {
        point = 0;
    }else if (point < _rightView && _cellStatus == CWTableViewCellStatusOpenRight) {
        point = -_rightView;
    }else if (point > _leftView && _cellStatus == CWTableViewCellStatusOpenLeft) {
        point = _leftView;
    }
    
    [self.contentView setFrame:CGRectMake(point , 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
}

#pragma mark - GestureRecognizer Event

//這邊可以處理接收事件要是給誰
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    NSLog(@"rgvcfgbvghnbvghnbghj, %@", NSStringFromCGPoint(point));
//    return hitView;
//}

- (void)tapAction:(UITapGestureRecognizer *) recognizer
{
    
}

- (void)panAction:(UIPanGestureRecognizer*) recognizer
{
    
    CGPoint panPoint = [recognizer velocityInView:self.contentView.superview];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (recognizer.numberOfTouches != 1) {
                _ignoreSwipe = YES;
                return;
            }
            _ignoreSwipe = NO;
            
            _startPoint = panPoint;
            _tempPoint = _startPoint;
            _turningPoint = _startPoint;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (_ignoreSwipe || (fabs(panPoint.x - _startPoint.x) < 10 && !_startSwipe )) {
                return;
            }else if (!_startSwipe){
                if (panPoint.x - _startPoint.x < 0) {
                    _cellStatus = CWTableViewCellStatusOpenRight;
                }else{
                    _cellStatus = CWTableViewCellStatusOpenLeft;
                }
            }
            
            _startSwipe = YES;
            //滑動時為了在初始的部分慨起來順暢都採用動畫的方式去做
            [(UITableView *)self.superview.superview setScrollEnabled:NO];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self contentViewMoveWithTargetPoint:self.contentView.frame.origin.x - (_startPoint.x - panPoint.x)];
            } completion:^(BOOL finished) {
                
            }];
            
            
            //當我當前狀態是關閉快鍵時，我現在的移動軌跡為向左則存轉折點
            //當我當前狀態是開啟快鍵時，我現在的移動軌跡為向右則存轉折點
            //暫存轉則點為了最後判別
            if (_tempPoint.x < panPoint.x) { //向右滑動
                
                if (_actionStatus != CWTableViewCellStatusNormal && _cellStatus == CWTableViewCellStatusOpenRight) {
                    _turningPoint = panPoint;
                    _actionStatus = CWTableViewCellStatusNormal;
                }else if (_actionStatus == CWTableViewCellStatusNormal && _cellStatus == CWTableViewCellStatusOpenLeft) {
                    _turningPoint = panPoint;
                    _actionStatus = CWTableViewCellStatusOpenLeft;
                }
                
                _actionStatus = CWTableViewCellStatusNormal;
            }else if (_tempPoint.x > panPoint.x ) { //向左滑動
                
                if (_actionStatus != CWTableViewCellStatusNormal && _cellStatus == CWTableViewCellStatusOpenLeft) {
                    _turningPoint = panPoint;
                    _actionStatus = CWTableViewCellStatusNormal;
                }else if (_actionStatus == CWTableViewCellStatusNormal && _cellStatus == CWTableViewCellStatusOpenRight) {
                    _turningPoint = panPoint;
                    _actionStatus = CWTableViewCellStatusOpenRight;
                }
            }
            
            //暫存上次移動的點
            _tempPoint = panPoint;
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (_ignoreSwipe || !_startSwipe ) {
                return;
            }
            
            if (panPoint.x - _turningPoint.x > 10 && _actionStatus == CWTableViewCellStatusOpenLeft && _cellStatus == CWTableViewCellStatusOpenLeft) {
                _cellStatus = CWTableViewCellStatusOpenLeft;
            }else if (panPoint.x - _turningPoint.x < 10 && _actionStatus == CWTableViewCellStatusOpenRight && _cellStatus == CWTableViewCellStatusOpenRight) {
                _cellStatus = CWTableViewCellStatusOpenRight;
            }else{
                _cellStatus = CWTableViewCellStatusNormal;
            }
            
            [self swipeViewStatue:_cellStatus];
            _startSwipe = NO;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - GestureRecognizer Delegate


@end
