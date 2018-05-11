//
//  EXSwitchTableViewCell.m
//  Exchange
//
//  Created by Jave on 2018/1/23.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXSwitchTableViewCell.h"

@interface EXSwitchTableViewCell ()

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation EXSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.switchControl = [UISwitch new];
        
        self.accessoryType = UITableViewCellAccessoryDetailButton;
        self.accessoryView = [self switchControl];
    }
    return self;
}

@end
