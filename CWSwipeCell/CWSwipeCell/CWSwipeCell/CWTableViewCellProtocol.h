//
//  CWTableViewCellProtocol.h
//  CWSwipeCell
//
//  Created by Li Chen wei on 2016/4/7.
//  Copyright © 2016年 TWML. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol CWTableViewCellProtocol <NSObject>

//會要求滑動Cell後出現的View
//當Cell Type選擇 CWTableViewCellStyleNormal       不會要求 View
//當Cell Type選擇 CWTableViewCellStyleRightSwipe   會要求一次Right View
//當Cell Type選擇 CWTableViewCellStyleLeftSwipe    會要求一次Left View
//當Cell Type選擇 CWTableViewCellStyleDoubleSided  會要求兩次次Right及Left View
- (UIView *)cellSwipeViewWithDirection:(NSString *)direction;


@end