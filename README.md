>功能描述：支持网络和本地gif、jpeg等格式图片的浏览、捏合或双击放大缩小、长按保存到本地相册、获取gif图片的循环次数和时长。

![效果预览.gif](http://upload-images.jianshu.io/upload_images/1708447-ecd9f5d2ac663540.gif?imageMogr2/auto-orient/strip)

主要部分：创建一个继承于UIScrollView的子类视图WSLPhotoZoom，这个视图需要一个展示图片的UIImageView，然后再结合UIScrollView自带的缩放手势的代理方法来达到缩放效果；最后只需要把这个能缩放的视图放到需要展示图片的视图上就行了。当然，也可以结合UIPinchGestureRecognizer（捏合手势）和UIPanGestureRecognizer（拖拽手势）来实现这样的效果。

```
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
     imageX = floorf((self.frame.size.width - imageScaleWidth) / 2.0);
     imageY = floorf((self.frame.size.height - imageScaleHeight) / 2.0);
     self.imageView.frame = CGRectMake(imageX, imageY, imageScaleWidth, imageScaleHeight);
    
}

```



与此功能相关的文章可以查看我之前的文章：
[iOS 获取gif图片循环次数和时长](http://www.jianshu.com/p/6cd7132e8997)
[UIScrollerView当前显示3张图](http://www.jianshu.com/p/2aa464ae84ca)
