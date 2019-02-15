//
//  WSLPhotoZoom.h
//  WSLPictureBrowser
//
//  Created by 王双龙 on 2017/6/27.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+GIF.h"

@interface WSLPhotoZoom : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * imageView;

//默认是屏幕的宽和高
@property (assign, nonatomic) CGFloat imageNormalWidth; // 图片未缩放时宽度
@property (assign, nonatomic) CGFloat imageNormalHeight; // 图片未缩放时高度

//缩放方法，共外界调用
- (void)pictureZoomWithScale:(CGFloat)zoomScale;

@end
