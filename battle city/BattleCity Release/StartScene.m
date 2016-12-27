//
//  StartScene.m
//  BattleCity
//
//  Created by 喆 肖 on 12-8-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "StartScene.h"
#import "MainScene.h"
#import "WinScene.h"
#import "AppDelegate.h"
#import "NewAppTableViewController.h"

@interface StartScene(PrivateMethods)

- (void)initMenum;

@end

@implementation StartScene

+(id)scene {
    
    CCScene* scene = [CCScene node];
    CCLayer* layer = [StartScene node];
    [scene addChild:layer];
    return scene;
}

- (id)init {
    
    if (self = [super init]) {
        [self initMenum];
    }
    return  self;
}


- (void)initMenum {
    

    [CCMenuItemFont setFontName:@"Helvetica-BoldOblique"];
    [CCMenuItemFont setFontSize:25];
    

    CCMenuItemFont* item1 = [CCMenuItemFont itemWithString:@"Start Game" target:self selector:@selector(menuItem1Touch:)];
    item1.position = ccp(0,-50);

//    CCMenuItemFont* item2 = [CCMenuItemFont itemWithString:@"More App" target:self selector:@selector(menuItem2Touch:)];
//    item2.position = ccp(0,-100);

    CCMenuItemImage* item3 = [CCMenuItemImage itemWithNormalImage:@"BattleCity.png" selectedImage:nil];
    item3.position = ccp(0,50);
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        item1.position = ccp(0,200);
//        item2.position = ccp(0,150);
        item3.position = ccp(0,300);
        if (isPad) {
            item1.position = ccp(0,500);
//            item2.position = ccp(0,450);
            item3.position = ccp(0,600);

        }
    }
    
    

    CCMenu* menu = [CCMenu menuWithItems:item1,item3, nil];
    
  
    [self addChild:menu];
    [APP_DELEGATE showAdmobBanner];
}
- (void)menuItem1Touch:(id)sender {
    
    
    if (_isRun) return;
    
    int level = [[[NSUserDefaults standardUserDefaults]valueForKey:@"currentLevel"]intValue];
    if (level == 0) {
    
        level= 1;
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:1] forKey:@"currentLevel"];
         [[NSUserDefaults standardUserDefaults]synchronize];
    }
    if (level >20) {
        level = 0;
        [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:level] forKey:@"currentLevel"];
         [[NSUserDefaults standardUserDefaults]synchronize];
    }
    CCScene* gameScene = [[ MainScene alloc] initWithMapInformation:level status:1 life:5];

    
    [[CCDirector sharedDirector] replaceScene:gameScene];
    [gameScene release];
    _isRun = YES;
     
}

- (void)menuItem2Touch:(id)sender {
    
    NewAppTableViewController *newApp = [[NewAppTableViewController alloc]initWithNibName:@"NewAppTableViewController" bundle:nil];
    [APP_DELEGATE.navController pushViewController:newApp animated:YES];
    
}
- (void)dealloc {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
    [super dealloc];
}
- (void)onExit {
    
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    [super onExit];
}
@end
