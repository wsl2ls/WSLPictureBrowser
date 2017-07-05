//
//  WSLPhotoZoom.m
//  WSLPictureBrowser
//
//  Created by 王双龙 on 2017/6/27.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "WSLPhotoZoom.h"

@implementation WSLPhotoZoom

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 2.0f;
        _imageNormalHeight = frame.size.height;
        _imageNormalWidth = frame.size.width;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{

    
}

#pragma mark -- Help Methods

- (void)resetUI{
    
    self.contentSize = CGSizeMake( self.imageNormalWidth, self.imageNormalHeight);
    self.imageView.frame = CGRectMake(0, 0, self.imageNormalWidth, self.imageNormalHeight);
    
}

- (void)pictureZoomWithScale:(CGFloat)zoomScale{
    
    // 延中心点缩放
    CGFloat imageScaleWidth = zoomScale * self.imageNormalWidth;
    CGFloat imageScaleHeight = zoomScale * self.imageNormalHeight;
    
    self.contentSize = CGSizeMake( imageScaleWidth, imageScaleHeight);
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;

    imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
    imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);

    self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
}


#pragma mark -- Setter

- (void)setImageNormalWidth:(CGFloat)imageNormalWidth{
    _imageNormalWidth = imageNormalWidth;
    self.imageView.frame = CGRectMake(0, 0, _imageNormalWidth, _imageNormalHeight);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (void)setImageNormalHeight:(CGFloat)imageNormalHeight{
    _imageNormalHeight = imageNormalHeight;
    self.imageView.frame = CGRectMake(0, 0, _imageNormalWidth, _imageNormalHeight);
    self.imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

#pragma mark -- UIScrollViewDelegate

//返回需要缩放的视图控件 缩放过程中
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//开始缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    NSLog(@"开始缩放");
}
//结束缩放
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    NSLog(@"结束缩放");
}

//缩放中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 延中心点缩放
    CGFloat imageScaleWidth = scrollView.zoomScale * self.imageNormalWidth;
    CGFloat imageScaleHeight = scrollView.zoomScale * self.imageNormalHeight;
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
//    if (imageScaleWidth < self.frame.size.width) {
        imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
//    }
//    if (imageScaleHeight < self.frame.size.height) {
        imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
//    }
    self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
    
}

@end
