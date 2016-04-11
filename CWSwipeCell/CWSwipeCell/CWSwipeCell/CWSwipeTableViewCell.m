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
        _cellStyle = style;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)initCellSetting
{
    _ignoreSwipe = YES;
    _startSwipe = NO;
    
    _cellStatus = CWTableViewCellStatusNormal;
    _actionStatus = CWTableViewCellStatusNormal;
    
    self.multipleTouchEnabled = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)]; // or use Pan
    panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:panGestureRecognizer];
    
}

- (UITableView *)superTableView
{
    if (nil == _superTableView) {
        UIView *view = self;
        while(view != nil) {
            if([view isKindOfClass:[UITableView class]]) {
                _superTableView = (UITableView *)view;
                break;
            }
            view = [view superview];
        }
    }
    return _superTableView;
}

#pragma mark - Swipe Method

- (void)swipeViewStatue:(CWTableViewCellStatus)cellStatus
{
    
    int _rightView = (_rightSwipeView == nil ? 0 :- _rightSwipeView.frame.size.width);
    int _leftView = (_leftSwipeView == nil ? 0 : _leftSwipeView.frame.size.width);
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        if (cellStatus == CWTableViewCellStatusOpenRight) {
            [self contentViewMoveWithTargetPoint:_rightView];
        }else if (cellStatus == CWTableViewCellStatusOpenLeft) {
            [self contentViewMoveWithTargetPoint:_leftView];
        }else{
            [self contentViewMoveWithTargetPoint:0];
        }
    } completion:^(BOOL finished) {
        if (finished) {
            [_superTableView setScrollEnabled:YES];
        }
    }];
    
}

- (void)contentViewMoveWithTargetPoint:(float)point //傳入應該要移動到的位置
{
    int _rightView = (_rightSwipeView == nil ? 0 : - _rightSwipeView.frame.size.width);
    int _leftView = (_leftSwipeView == nil ? 0 : _leftSwipeView.frame.size.width);
    
    if (_cellStatus == CWTableViewCellStatusOpenRight) {
        
        if (_actionStatus == CWTableViewCellStatusOpenRight && point < _rightView) {
            point = _rightView;
        }
        if (_actionStatus == CWTableViewCellStatusNormal && point > 0) {
            point = 0;
        }
    }else if (_cellStatus == CWTableViewCellStatusOpenLeft) {
        
        if (_actionStatus == CWTableViewCellStatusOpenLeft && point > _leftView) {
            point = _leftView;
        }
        if (_actionStatus == CWTableViewCellStatusNormal && point < 0) {
            point = 0;
        }
        
    }
    
    [self.contentView setFrame:CGRectMake(point , 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
}

#pragma mark - GestureRecognizer Event

- (void)panAction:(UIPanGestureRecognizer*) recognizer
{
    
    CGPoint panPoint = [recognizer locationInView:self];
    CGPoint superPoint = [recognizer locationInView:_superTableView.superview];
    
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (recognizer.numberOfTouches != 1) {
                _ignoreSwipe = YES;
                return;
            }else if (_actionStatus != CWTableViewCellStatusNormal) {
                
                [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    [self contentViewMoveWithTargetPoint:0];
                } completion:^(BOOL finished) {
                }];
                _actionStatus = CWTableViewCellStatusNormal;

                _ignoreSwipe = YES;
                return;
            }
            _ignoreSwipe = NO;
            
            _startPoint = panPoint;
            _startSuperPoint = superPoint;
            _tempPoint = _startPoint;
            _turningPoint = _startPoint;
            _superTableView = [self superTableView];
            
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (fabs(superPoint.y - _startSuperPoint.y) > 10  && !_startSwipe ) {
                _ignoreSwipe = YES;
                return;
            }else if (_ignoreSwipe || (fabs(panPoint.x - _startPoint.x) < 10 && !_startSwipe )) {
                return;
            }else if (!_startSwipe){
                
                int _width = self.frame.size.width;
                
                if (panPoint.x - _startPoint.x < 0 && (_cellStyle == CWTableViewCellStyleRight || _cellStyle == CWTableViewCellStyleDoubleSided)) { //左滑
                    _cellStatus = CWTableViewCellStatusOpenRight;
                    
                    //如果沒有右邊的View的話，就來進入判定加入
                    if (_rightSwipeView == nil && [_delegate respondsToSelector:@selector(cellSwipeViewWithDirection:)]) {
                        _rightSwipeView = [_delegate cellSwipeViewWithDirection:@"CWTableViewCellStyleRight"];
                        _rightSwipeView.frame = CGRectMake(_width - _rightSwipeView.frame.size.width, 0, _rightSwipeView.frame.size.width, _rightSwipeView.frame.size.height);
                        [self.contentView.superview addSubview:_rightSwipeView];
                        [self.contentView.superview bringSubviewToFront:self.contentView];
                    }
                    
                    
                }else if (panPoint.x - _startPoint.x > 0 && (_cellStyle == CWTableViewCellStyleLeft || _cellStyle == CWTableViewCellStyleDoubleSided)){ //右滑
                    _cellStatus = CWTableViewCellStatusOpenLeft;
                    
                    //如果沒有左邊的View的話，就來進入判定加入
                    if (_leftSwipeView == nil && [_delegate respondsToSelector:@selector(cellSwipeViewWithDirection:)]) {
                        _leftSwipeView = [_delegate cellSwipeViewWithDirection:@"CWTableViewCellStyleLeft"];
                        
                        _leftSwipeView.frame = CGRectMake(0, 0, _leftSwipeView.frame.size.width, _leftSwipeView.frame.size.height);

                        [self.contentView.superview addSubview:_leftSwipeView];
                        [self.contentView.superview bringSubviewToFront:self.contentView];
                    }
                    
                }else{
                    _ignoreSwipe = YES;
                    return;
                }
            }
            
            _startSwipe = YES;
            //滑動時為了在初始的部分慨起來順暢都採用動畫的方式去做
            [_superTableView setScrollEnabled:NO];
            //使用 UIViewAnimationOptionAllowUserInteraction 允許使用者在動畫過程中有其他的觸發事件
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self contentViewMoveWithTargetPoint:self.contentView.frame.origin.x - (_tempPoint.x - panPoint.x)];
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
            
            _actionStatus = _cellStatus;
            [self swipeViewStatue:_cellStatus];
            _startSwipe = NO;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
