//
//  RulerReportModel.m
//  GoodType
//
//  Created by Senchor on 2018/1/11.
//  Copyright © 2018年 Senchor. All rights reserved.
//

#import "RulerReportModel.h"

@implementation RulerReportModel

- (CGFloat)calCellH {
    CGFloat h = 0;
    if (self.fold) {
        if (self.arrM.count < 5) {
            h = self.arrM.count * 44;
        } else {
            h = 5*44;
        }
    } else {
        h = self.arrM.count * 44;
    }
    h += 25;  // 展开按钮的高度
    self.height = h;
    return h;
}

@end
