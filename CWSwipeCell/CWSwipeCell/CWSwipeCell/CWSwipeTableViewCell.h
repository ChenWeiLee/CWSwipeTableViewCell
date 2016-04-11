//
//  CWSwipeTableViewCell.h
//  CWSwipeCell
//
//  Created by Li Chen wei on 2016/4/7.
//  Copyright © 2016年 TWML. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWTableViewCellProtocol.h"

typedef NS_ENUM(NSInteger, CWTableViewCellStyle)
{
    CWTableViewCellStyleNormal = 0,
    CWTableViewCellStyleRight,
    CWTableViewCellStyleLeft,
    CWTableViewCellStyleDoubleSided
};

typedef NS_ENUM(NSInteger, CWTableViewCellStatus)
{
    CWTableViewCellStatusNormal = 0,
    CWTableViewCellStatusOpenRight,
    CWTableViewCellStatusOpenLeft,
};

@interface CWSwipeTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CWTableViewCellProtocol> delegate;

@property (nonatomic) CGPoint startPoint;       //滑動起始點
@property (nonatomic) CGPoint startSuperPoint;  //滑動起始點(對應TableView的Super)
@property (nonatomic) CGPoint tempPoint;        //滑動時的上一個點
@property (nonatomic) CGPoint turningPoint;     //轉折點
@property (nonatomic) CWTableViewCellStyle cellStyle;
@property (nonatomic) CWTableViewCellStatus cellStatus;


@property (nonatomic, strong) UIView *rightSwipeView;
@property (nonatomic, strong) UIView *leftSwipeView;

@property (nonatomic, strong) UITableView *superTableView;

- (instancetype)initWithTableViewCellType:(CWTableViewCellStyle)style reuseIdentifier:(NSString *)reuseID;

@end
