//
//  NCWordImageViewController.m
//  NakedChinese
//
//  Created by IMAC  on 18.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWordImageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NCWordImageViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;

@end

@implementation NCWordImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.image setImage:self.img];
    
    [self.image setFrame:CGRectMake(self.image.frame.origin.x, self.image.frame.origin.y, self.image.image.size.width, self.image.image.size.height)];
    NSLog(@"%@", NSStringFromCGRect(CGRectMake(self.image.frame.origin.x, self.image.frame.origin.y, self.image.image.size.width, self.image.image.size.height)));
    NSLog(@"%@", NSStringFromCGRect(CGRectMake(self.image.frame.origin.x, self.image.frame.origin.y, self.image.frame.size.width, self.image.frame.size.height)));
    
    [self.scroll setFrame:self.image.frame];
    [self.scroll setContentSize:self.image.frame.size];
    NSLog(@"%@", NSStringFromCGRect(CGRectMake(self.scroll.frame.origin.x, self.scroll.frame.origin.y, self.scroll.frame.size.width, self.scroll.frame.size.height)));
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scroll addGestureRecognizer:doubleTapRecognizer];
    
    CGRect scrollViewFrame = self.scroll.frame;
    //float scaleWidth = scrollViewFrame.size.width / self.scroll.contentSize.width;
   // float scaleHeight = scrollViewFrame.size.height / self.scroll.contentSize.height;
    //float minScale = MIN(scaleHeight, scaleWidth);
    self.scroll.minimumZoomScale = 1;
    
    self.scroll.maximumZoomScale = 2.0f;
    self.scroll.zoomScale = 1;
    
    [self centerScrollViewContents];
}

- (void) centerScrollViewContents
{
    CGSize boundSize = self.scroll.bounds.size;
    CGRect contentsFrame = self.image.frame;
    
    if(contentsFrame.size.width < boundSize.width)
    {
        contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if(contentsFrame.size.height < boundSize.height)
    {
        contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.image.frame = contentsFrame;
}

- (void) scrollViewDoubleTapped:(UITapGestureRecognizer *)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.image];
    
    float  newZoomScale = self.scroll.zoomScale * 2.0f;
    if(newZoomScale == 4.0f)
    {
        newZoomScale = 1.0f;
    }
    else
    {
        newZoomScale = MIN(newZoomScale, self.scroll.maximumZoomScale);
    }
    NSLog(@"new zoom scale = %f", newZoomScale);
    
    CGSize scrollViewSize = self.scroll.bounds.size;
    float w = scrollViewSize.width / newZoomScale;
    float h = scrollViewSize.height / 2.0f;
    float x = pointInView.x - (w/2.0f);
    float y = pointInView.y - (h/2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scroll zoomToRect:rectToZoomTo animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.image;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerScrollViewContents];
}


@end
