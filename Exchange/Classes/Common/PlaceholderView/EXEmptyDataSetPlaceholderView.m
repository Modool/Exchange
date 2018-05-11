//
//  EXEmptyDataSetPlaceholderView.m
//  Exchange
//
//  Created by 徐林峰 on 2018/1/4.
//  Copyright © 2018年 Exchange. All rights reserved.
//

#import "EXEmptyDataSetPlaceholderView.h"
#import <objc/runtime.h>

@interface _BBLinkEmptyDataSetPlaceholderViewButton : UIButton
@end
@implementation _BBLinkEmptyDataSetPlaceholderViewButton

- (CGSize)intrinsicContentSize{
    NSString *title = [self titleForState:[self state]];
    CGSize contentSize = [title sizeWithAttributes:@{NSFontAttributeName: [[self titleLabel] font]}];
    contentSize.width += 45 * 2;
    contentSize.height += (6.5 * 2 + 4);
    return contentSize;
}

@end

@interface _YROffsetView : UIView
@end
@implementation _YROffsetView
@end

@interface EXEmptyDataSetPlaceholderView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) NSMutableArray<UIView *> *mutableItemViews;

@end

@interface UIView (EXEmptyDataSetPlaceholderViewOffset)

@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewOffset;
@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewContentHeight;
@property (nonatomic, assign) CGFloat emptyDataSetPlaceholderViewContentWidth;

@end

@implementation UIView (EXEmptyDataSetPlaceholderViewOffset)

- (CGFloat)emptyDataSetPlaceholderViewOffset{
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewOffset)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewOffset:(CGFloat)emptyDataSetPlaceholderViewOffset{
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewOffset), @(emptyDataSetPlaceholderViewOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)emptyDataSetPlaceholderViewContentHeight{
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentHeight)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewContentHeight:(CGFloat)emptyDataSetPlaceholderViewContentHeight{
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentHeight), @(emptyDataSetPlaceholderViewContentHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)emptyDataSetPlaceholderViewContentWidth{
    return [objc_getAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentWidth)) floatValue];
}

- (void)setEmptyDataSetPlaceholderViewContentWidth:(CGFloat)emptyDataSetPlaceholderViewContentWidth{
    objc_setAssociatedObject(self, @selector(emptyDataSetPlaceholderViewContentWidth), @(emptyDataSetPlaceholderViewContentWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation EXEmptyDataSetPlaceholderView

+ (instancetype)placeholder;{
    return [self placeholderWithImage:0];
}

+ (instancetype)placeholderWithImage:(UIImage *)image;{
    return [self placeholderWithImage:image title:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title;{
    return [self placeholderWithImage:image title:title subtitle:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;{
    return [self placeholderWithImage:image title:title subtitle:subtitle buttonTitle:nil];
}

+ (instancetype)placeholderWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle;{
    return [[self alloc] initWithImage:image title:title subtitle:subtitle buttonTitle:buttonTitle];
}

- (instancetype)initWithImage:(UIImage *)image;{
    return [self initWithImage:image title:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;{
    return [self initWithImage:image title:title subtitle:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;{
    return [self initWithImage:image title:title subtitle:subtitle buttonTitle:nil];
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle buttonTitle:(NSString *)buttonTitle;{
    if (self = [self init]) {
        if (image) {
            [self appendImage:image completion:nil];
        }
        if (title) {
            [self appendTitle:title completion:nil];
        }
        if (subtitle) {
            [self appendSubTitle:subtitle completion:nil];
        }
        if (buttonTitle) {
            [self appendButtonWithTitle:buttonTitle completion:nil];
        }
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self _initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self _initialize];
    }
    return self;
}

- (void)appendImage:(UIImage *)image completion:(void (^)(UIImageView *imageView, CGFloat *offset, CGFloat *height, CGFloat *width))completion;{
    UIImageView *imageView = [self defaultImageView];
    imageView.image = image;
    
    [self _appendFreeView:imageView offset:10 completion:(id)completion];
}

- (void)appendTitle:(NSString *)title completion:(void (^)(UILabel *titleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion;{
    UILabel *titleLabel = [self defaultTitleLabel];
    titleLabel.text = title;
    
    [self _appendFreeView:titleLabel offset:9 completion:(id)completion];
}

- (void)appendSubTitle:(NSString *)subtitle completion:(void (^)(UILabel *subtitleLabel, CGFloat *offset, CGFloat *height, CGFloat *width))completion;{
    UILabel *subtitleLabel = [self defaultSubtitleLabel];
    subtitleLabel.text = subtitle;
    
    [self _appendFreeView:subtitleLabel offset:4 completion:(id)completion];
}

- (void)appendButtonWithTitle:(NSString *)title completion:(void (^)(UIButton *button, CGFloat *offset, CGFloat *height, CGFloat *width))completion;{
    UIButton *button = [self defaultButton];
    [button setTitle:title forState:UIControlStateNormal];
    
    [self _appendFreeView:button offset:10 completion:(id)completion];
}

- (void)appendSeparatorWithBackgroundColor:(UIColor *)backgroundColor completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion;{
    UIView *view = [self defaultView];
    view.backgroundColor = backgroundColor;
    
    [self _appendView:view offset:10 completion:(id)completion];
}

- (void)appendView:(UIView *)view completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion{
    [self _appendFreeView:view offset:0 completion:completion];
}

- (void)_appendFreeView:(UIView *)view offset:(CGFloat)offset completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion{
    [self _appendView:view offset:offset completion:^(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width) {
        if (completion) completion(view, offset, height, width);
    }];
}

- (void)_appendView:(UIView *)view offset:(CGFloat)offset completion:(void (^)(UIView *view, CGFloat *offset, CGFloat *height, CGFloat *width))completion{
    CGFloat contentHeight = -1;
    CGFloat contentWidth = -1;
    if (completion) {
        completion(view, &offset, &contentHeight, &contentWidth);
    }
    view.emptyDataSetPlaceholderViewOffset = offset;
    view.emptyDataSetPlaceholderViewContentHeight = contentHeight;
    view.emptyDataSetPlaceholderViewContentWidth = contentWidth;
    
    [[self contentView] addSubview:view];
    [[self mutableItemViews] addObject:view];
    
    [self _updateItemViewslayout];
}

#pragma mark - accessor

- (void)setContentInsets:(UIEdgeInsets)contentInsets{
    _contentInsets = contentInsets;
    
    [self _updateContentViewLayout];
}

- (UIImageView *)defaultImageView{
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    return imageView;
}

- (UILabel *)defaultTitleLabel{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    return titleLabel;
}

- (UILabel *)defaultSubtitleLabel{
    UILabel *subtitleLabel = [UILabel new];
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    subtitleLabel.textAlignment = NSTextAlignmentCenter;
    subtitleLabel.numberOfLines = 0;
    return subtitleLabel;
}

- (UIButton *)defaultButton{
    UIButton *button = [_BBLinkEmptyDataSetPlaceholderViewButton new];
    button.userInteractionEnabled = NO;
    button.layer.cornerRadius = 4.f;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.numberOfLines = 0;
    button.backgroundColor = [UIColor colorWithRed:0.98 green:0.45 blue:0.60 alpha:1.00];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    return button;
}

- (UIView *)defaultView{
    UIView *defaultView = [UIView new];
    return defaultView;
}

- (_YROffsetView *)defaultOffsetView{
    _YROffsetView *offsetView = [_YROffsetView new];
    offsetView.userInteractionEnabled = NO;
    return offsetView;
}

- (UIView *)DZNEmptyDataSetView{
    UIView *superview = self;
    while (superview && ![superview isKindOfClass:NSClassFromString(@"DZNEmptyDataSetView")]){
        superview = [superview superview];
    };
    return superview;
}

#pragma mark - protected

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self _updateContentSize];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    [self _updateContentSize];
}

#pragma mark - private

- (void)_initialize{
    
    self.mutableItemViews = [NSMutableArray array];
    
    self.contentView = [UIView new];
    [self addSubview:[self contentView]];
    
    self.contentInsets = UIEdgeInsetsMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
}

- (void)_updateContentViewLayout{
    
    [[self contentView] mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.contentInsets.top != CGFLOAT_MAX || self.contentInsets.bottom != CGFLOAT_MAX) {
            if (self.contentInsets.top != CGFLOAT_MAX) {
                make.top.equalTo(self).offset(self.contentInsets.top);
            }
            if (self.contentInsets.bottom != CGFLOAT_MAX) {
                make.bottom.equalTo(self).offset(self.contentInsets.bottom);
            }
        } else {
            make.centerY.equalTo(self);
        }
        if (self.contentInsets.left != CGFLOAT_MAX || self.contentInsets.right != CGFLOAT_MAX) {
            if (self.contentInsets.left != CGFLOAT_MAX) {
                make.left.equalTo(self).offset(self.contentInsets.left);
            }
            if (self.contentInsets.right != CGFLOAT_MAX) {
                make.right.equalTo(self).offset(self.contentInsets.right);
            }
        } else {
            make.centerX.equalTo(self);
        }
    }];
    
    
}

- (void)_updateItemViewslayout{
    NSArray *itemViews = [[self mutableItemViews] copy];
    [itemViews enumerateObjectsUsingBlock:^(UIView *itemView, NSUInteger index, BOOL *stop) {
       [itemView mas_remakeConstraints:^(MASConstraintMaker *make) {
           make.left.greaterThanOrEqualTo(self.contentView);
           make.right.lessThanOrEqualTo(self.contentView);
           make.centerX.equalTo(self.contentView);
           CGFloat offset = [itemView emptyDataSetPlaceholderViewOffset];
           if (!index) {
               make.top.equalTo(self.contentView).offset(offset);
           } else {
               UIView *previousItemView = itemViews[index - 1];
               make.top.equalTo(previousItemView.mas_bottom).offset(offset);
           }
           if (index == [itemViews count] - 1) {
               make.bottom.equalTo(self.contentView);
           }
           if ([itemView emptyDataSetPlaceholderViewContentHeight] >= 0) {
               make.height.mas_equalTo(itemView.emptyDataSetPlaceholderViewContentHeight);
           }
           if ([itemView emptyDataSetPlaceholderViewContentWidth] >= 0) {
               make.width.mas_equalTo(itemView.emptyDataSetPlaceholderViewContentWidth);
           }
       }];
    }];
}

- (void)_updateContentSize{
    UIView *DZNEmptyDataSetView = [self DZNEmptyDataSetView];
    if (DZNEmptyDataSetView) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([[self DZNEmptyDataSetView] bounds].size);
        }];
    }
}

@end
