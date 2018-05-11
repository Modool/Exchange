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

@property (nonatomic, strong) NSArray<EXTrade *> *trades;

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

- (void)setTrades:(NSArray<EXTrade *> *)trades{
    if (_trades != trades) {
        _trades = trades;
        
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.trades.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EXClassName(UITableViewCell)];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EXClassName(UITableViewCell)];
    
    EXTrade *trade = self.trades[indexPath.row];
    cell.textLabel.text = fmts(@"%.8f", trade.price);
    cell.detailTextLabel.text = fmts(@"%.8f", trade.amount);
    
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
    
    [self.buyContentView mas_makeConstraints:^(MASConstraintMaker *make) {
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
