//
//  CWSwipeTableViewCell.h
//  CWSwipeCell
//
//  Created by Li Chen wei on 2016/4/7.
//  Copyright © 2016年 TWML. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CWTableViewCellStyle)
{
    CWTableViewCellStyleNormal = 0,
    CWTableViewCellStyleRightSwipe,
    CWTableViewCellStyleLeftSwipe,
    CWTableViewCellStyleDoubleSided
};

typedef NS_ENUM(NSInteger, CWTableViewCellStatus)
{
    CWTableViewCellStatusNormal = 0,
    CWTableViewCellStatusOpenRight,
    CWTableViewCellStatusOpenLeft,
};

@interface CWSwipeTableViewCell : UITableViewCell

@property (nonatomic) CGPoint startPoint;   //暫存滑動起試點
@property (nonatomic) CGPoint tempPoint;    //暫存滑動時的上一個點
@property (nonatomic) CGPoint turningPoint; //暫存轉折點
@property (nonatomic) CWTableViewCellStatus cellStatus;


@property (nonatomic, strong) UIView *rightSwipeView;
@property (nonatomic, strong) UIView *leftSwipeView;

@end
