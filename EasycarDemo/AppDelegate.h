//
//  AppDelegate.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/24.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

