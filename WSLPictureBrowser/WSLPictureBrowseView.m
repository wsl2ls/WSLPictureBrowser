//
//  WSLPictureBrowseView.m
//  WSLPictureBrowser
//
//  Created by 王双龙 on 2017/6/28.
//  Copyright © 2017年 王双龙. All rights reserved.
//

#import "WSLPictureBrowseView.h"
#import "UIImageView+GIF.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.3f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS10_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.1f)

@interface WSLPictureBrowseView () <UIScrollViewDelegate>


@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UILabel * indexLabel;

@property (nonatomic, strong) NSMutableArray * imageDataArray;

@property (nonatomic, assign) BOOL doubleTap;

@end


@implementation WSLPictureBrowseView


- (id)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        _imageDataArray = [NSMutableArray array];
        
        [self addGestureRecognizer];
        
        [self addSubview:self.scrollView];
        [self addSubview:self.indexLabel];
        
    }
    return self;
    
}

//添加手势
- (void)addGestureRecognizer{
    
    self.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer * longGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGR:)];
    [self addGestureRecognizer:longGR];
    
    UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
}

#pragma mark -- Event Handle

- (void)doubleTap:(UITapGestureRecognizer *)tap{
    
    if (!_doubleTap) {
        [self.currentPhotoZoom pictureZoomWithScale:self.currentPhotoZoom.maximumZoomScale];
        _doubleTap = YES;
    }else{
        [self.currentPhotoZoom pictureZoomWithScale:self.currentPhotoZoom.minimumZoomScale];
        _doubleTap = NO;
    }
    
}

- (void)longGR:(UILongPressGestureRecognizer *)longGr{
    
    if (!self.viewController) {
        return;
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * saveAction = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:self.currentImageData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            NSString * message;
            if ([assetURL path].length > 0) {
                message = @"保存成功";
            }else{
                message = @"保存失败";
            }
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[self contentTypeForImageData:self.currentImageData] message:message preferredStyle:UIAlertControllerStyleAlert];
            [self.viewController presentViewController:alertController animated:YES completion:nil];
            [UIView animateWithDuration:2.0 animations:^(){} completion:^(BOOL finished) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
        }] ;
        
        
    }];
    [alertController addAction:saveAction];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancleAction];
    
    
    if(iOS8Later){
        [saveAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
        [cancleAction setValue:[UIColor grayColor] forKey:@"titleTextColor"];
    }
    
    [self.viewController presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark -- Help Methods


- (void)setupImageView:(NSMutableArray *)array{
    
    self.count = array.count;
    
    for (WSLPhotoZoom *photoZoom in self.scrollView.subviews) {
        [photoZoom removeFromSuperview];
    }
    self.indexLabel.text = [NSString stringWithFormat:@"1/%d",array.count];
    self.scrollView.contentSize = CGSizeMake(array.count * self.frame.size.width, self.frame.size.height);
    
    for (int i = 0; i < array.count ; i++) {
        
        WSLPhotoZoom * photoZoomView = [[WSLPhotoZoom alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        photoZoomView.imageNormalWidth = self.frame.size.width;
        photoZoomView.imageNormalHeight = 375;
        photoZoomView.backgroundColor =[UIColor blackColor];
        if (array == _pathArray) {
            //获取本地图片
            [photoZoomView.imageView showGifImageWithData:[NSData dataWithContentsOfFile:array[i]]];
            
            [self.imageDataArray addObject:[NSData dataWithContentsOfFile:array[i]]];
            
        }else if(array == _nameArray){
            
            //获取本地图片
            NSArray * nameStr = [array[i] componentsSeparatedByString:@"."];
            NSString * name = [nameStr  firstObject];
            NSString * type = [nameStr  lastObject];
            [photoZoomView.imageView showGifImageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]];
            [self.imageDataArray addObject:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]];
            
        }else{
            
            //获取网络图片
            [photoZoomView.imageView showGifImageWithURL:[NSURL URLWithString:array[i]]];
            [self.imageDataArray addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:array[i]]]];
        }
        
        [self.scrollView addSubview:photoZoomView];
        [self addSubview:self.indexLabel];
    }
    
    self.currentImageData = self.imageDataArray.firstObject;
    self.currentPhotoZoom = (WSLPhotoZoom *)(self.scrollView.subviews.firstObject);
    
}

//返回图片格式
- (NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg格式";
            
        case 0x89:
            
            return @"png格式";
            
        case 0x47:
            
            return @"gif格式";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff格式";
            
        case 0x52:
            
        default:
            break;
            
    }
    
    if ([data length] < 12) {
        
        return @"";
        
    }
    return @"";
}

#pragma mark -- Setter

- (void)setUrlArray:(NSMutableArray *)urlArray{
    
    _urlArray = urlArray;
    
    [self setupImageView:_urlArray];
    
}


- (void)setPathArray:(NSMutableArray *)pathArray{
    
    _pathArray = pathArray;
    
    [self setupImageView:_pathArray];
}


- (void)setNameArray:(NSMutableArray *)nameArray{
    
    _nameArray = nameArray;
    
    [self setupImageView:_nameArray];
    
}

#pragma mark -- Getter

- (UIScrollView *)scrollView{
    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blackColor];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior =  UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _scrollView.pagingEnabled = YES;
    }
    
    return _scrollView;
}

- (UILabel *)indexLabel{
    
    if (_indexLabel == nil) {
        
        _indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 25, 20, 40, 40)];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _indexLabel;
}

#pragma mark -- UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    self.index = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    //    NSLog(@"滑动至第 %d",self.index);
    
}

//滚动完毕就会调用（如果不是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.index = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    //    NSLog(@"滑动至第 %d",self.index);
    
}

//滚动完毕后就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger scrollIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    //    NSLog(@"scrollIndex %d",scrollIndex);
    if (scrollIndex != self.index) {
        //重置上一个缩放过的视图
        WSLPhotoZoom * zoomView  = (WSLPhotoZoom *)scrollView.subviews[self.index];
        [zoomView pictureZoomWithScale:1.0];
        
        self.index = scrollIndex;
        self.currentPhotoZoom = (WSLPhotoZoom *)scrollView.subviews[self.index];
        self.currentImageData = self.imageDataArray[self.index] ;
    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"%d/%d", self.index + 1,self.count];
    
}





@end
