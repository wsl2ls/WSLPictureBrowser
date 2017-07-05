//
//  UIImageView+GIF.h
//  WSLPictureBrowser
//
//  Created by 王双龙 on 2017/6/14.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImageView (GIF)


- (void)showGifImageWithData:(NSData *)data;

- (void)showGifImageWithURL:(NSURL *)url;

@end
