//
//  EffectImageViewController.m
//  TabbarViewControllerText
//
//  Created by Rongheng on 16/6/24.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "EffectImageViewController.h"

#import "UIImage+ImageEffects.h"

@interface EffectImageViewController ()

@end

@implementation EffectImageViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navBar.navigationBarTitle.text = @"高斯模糊";
    self.view.backgroundColor = [z_UI colorWithHexString:@"#48D1CC"];
    [self initImageView];
}

- (void)initImageView
{
    for (int i = 0; i<3; i++) {
        for (int j = 0; j<2; j++) {
            UIImageView *effectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+180*j, 104+180*i, 150, 150)];
            NSString *imageName = [NSString stringWithFormat:@"IMG_096%d.JPG",i+5];
            [self.view addSubview:effectImageView];
    
            UIImage *bgImage = [UIImage imageNamed:imageName];
            UIImage *effectImage;
            if (i == 0) {
                if (j == 1) {
                    effectImage = [bgImage applyDarkEffect];
                } else {
                    effectImage = bgImage;
                }
            } else if (i == 1){
                if (j == 0) {
                    effectImage = [bgImage applyExtraLightEffect];
                } else {
                    effectImage = [bgImage applyLightEffect];
                }
            } else {
                if (j == 0) {
                    effectImage = [bgImage applyTintEffectWithColor:[UIColor orangeColor]];
                } else {
                    effectImage = [bgImage applyBlurWithRadius:2 tintColor:[UIColor redColor] saturationDeltaFactor:3 maskImage:bgImage];
                }
            }
            effectImageView.image = effectImage;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
