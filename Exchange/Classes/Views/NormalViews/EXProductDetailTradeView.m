//
//  EXProductDetailTradeView.m
//  Exchange
//
//  Created by xulinfeng on 2018/5/4.
//  Copyright © 2018年 markejave. All rights reserved.
//

#import "EXProductDetailTradeView.h"

@interface EXProductDetailTradeContentView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, copy) NSArray<EXTradeSet *> *trades;

@end

@implementation EXProductDetailTradeContentView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.allowsSelection = NO;
        
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setTrades:(NSArray<EXTradeSet *> *)trades{
    if (_trades != trades) {
        _trades = trades;
        
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return MIN(self.trades.count, 10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EXClassName(UITableViewCell)];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EXClassName(UITableViewCell)];
    
    NSUInteger count = self.trades.count;
    EXTradeSet *trade = self.trades[count - indexPath.row - 1];
    UIColor *textColor = trade.buy ? [UIColor colorWithRed:0.24 green:0.65 blue:0.35 alpha:1.00] : [UIColor colorWithRed:0.90 green:0.27 blue:0.26 alpha:1.00];
    
    cell.textLabel.textColor = textColor;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.text = [NSString stringFromDoubleValue:trade.price];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.text = [NSString stringFromDoubleValue:trade.amount];
    
    return cell;
}

@end


@interface EXProductDetailTradeView ()

@property (nonatomic, strong) EXProductDetailTradeContentView *buyContentView;
@property (nonatomic, strong) EXProductDetailTradeContentView *sellContentView;

@end

@implementation EXProductDetailTradeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _createSubviews];
        [self _initializeSubviews];
        [self _installConstraints];
    }
    return self;
}

#pragma mark - private

- (void)_createSubviews{
    self.buyContentView = [[EXProductDetailTradeContentView alloc] init];
    self.sellContentView = [[EXProductDetailTradeContentView alloc] init];
    
    [self addSubview:self.buyContentView];
    [self addSubview:self.sellContentView];
}

- (void)_initializeSubviews{
}

- (void)_installConstraints{
    [self.buyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.right.equalTo(self.mas_centerX);
    }];
    
    [self.sellContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.left.equalTo(self.mas_centerX);
    }];
}

#pragma mark - public

- (void)bindViewModel:(EXProductDetailTradeViewModel *)viewModel{
    _viewModel = viewModel;
    
    RAC(self.buyContentView, trades) = RACObserve(viewModel, buyTrades);
    RAC(self.sellContentView, trades) = RACObserve(viewModel, sellTrades);
}

@end
