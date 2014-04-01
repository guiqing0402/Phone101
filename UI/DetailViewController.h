//
//  DetailViewController.h
//  Phone101
//
//  Created by GuiQing on 4/2/14.
//  Copyright (c) 2014 GuiQing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
