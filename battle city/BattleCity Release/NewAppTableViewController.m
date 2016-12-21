//
//  NewAppTableViewController.m
//  KiemHiep
//
//  Created by NRHVietNam on 5/3/15.
//
//

#import "NewAppTableViewController.h"
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"


@interface NewAppTableViewController (){
    NSMutableArray *arrGame;
    NSMutableArray *arrApp;
    
    NSMutableDictionary *arrImgGame;
    NSMutableDictionary *arrImgApp;
}

@end

@implementation NewAppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrGame = [[NSMutableArray alloc]init];
    arrApp = [[NSMutableArray alloc]init];
    arrImgGame = [[NSMutableDictionary alloc]init];
    arrImgApp = [[NSMutableDictionary alloc]init];
    [self loadData];
//     [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundBookShelf.png"]]] ;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    APP_DELEGATE.navController.navigationBarHidden = false;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     APP_DELEGATE.navController.navigationBarHidden = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section ==1) {
        return arrApp.count;
    }
    return arrGame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *ti;
    if (section == 1) {
        ti = @"App";
    }else{
        ti = @"Game";
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width , 50)];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, self.tableView.frame.size.width -20, 40)];
    Title.text = ti;
    Title.numberOfLines = 0;
    Title.textColor = [UIColor blackColor];
    Title.font = [UIFont systemFontOfSize:25];
    
    [view addSubview:Title];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

          UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    NSMutableArray *arr;
     NSMutableDictionary *arrImg;
    if (indexPath.section == 1) {
        arr = arrApp;
        arrImg = arrImgApp;
    }else{
        arr = arrGame;
        arrImg = arrImgGame;
    }
    if ([arrImg valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]) {
        UIImage *img = [[UIImage alloc] initWithData:[arrImg valueForKey:[NSString stringWithFormat:@"%ld",indexPath.row]]];
        cell.imageView.image = img;

    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://docs.google.com/uc?authuser=0&id=%@&export=download",[[arr objectAtIndex:indexPath.row]valueForKey:@"appImage" ]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        [arrImg setValue:data forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.imageView.image = img;
    }
    
    
            
    
   
    
   
    
   
    if ([PARSE_APP_LANGUAGE isEqualToString:@"Eng"]) {
  
         UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 200, 40)];
        Title.text = [NSString stringWithFormat:@"%@(%@)", [[arr objectAtIndex:indexPath.row] valueForKey:@"appTitleEnglish"], [[arr objectAtIndex:indexPath.row] valueForKey:@"deviceType"]];
       
        Title.numberOfLines = 0;
        Title.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:Title];
        
        UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, self.tableView.frame.size.width - 120, 60)];
        des.text =  [[arr objectAtIndex:indexPath.row] valueForKey:@"appDescriptionEnglish"];
         des.numberOfLines = 0;
        des.font = [UIFont systemFontOfSize:9];
   
        [cell.contentView addSubview:des];
        
    }else{
 
        UILabel *Title = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, self.tableView.frame.size.width -120, 40)];
        Title.text = [NSString stringWithFormat:@"%@(%@)", [[arr objectAtIndex:indexPath.row] valueForKey:@"appTitleViet"], [[arr objectAtIndex:indexPath.row] valueForKey:@"deviceType"]];
       
        Title.numberOfLines = 0;
        Title.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:Title];
        
        UILabel *des = [[UILabel alloc]initWithFrame:CGRectMake(120, 40, self.tableView.frame.size.width -120, 60)];
        des.text =  [[arr objectAtIndex:indexPath.row] valueForKey:@"appDescriptionViet"];
        des.numberOfLines = 0;
        des.font = [UIFont systemFontOfSize:9];
        [cell.contentView addSubview:des];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *arr;
    if (indexPath.section == 1) {
        arr = arrApp;
    }else{
        arr = arrGame;
    }
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[arr objectAtIndex:indexPath.row] valueForKey:@"link"]]];
}

- (void)loadData {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CLASS_NEW_APP];
//    [query whereKey:@"appLanguage" equalTo:PARSE_APP_LANGUAGE];
    [query orderByAscending:@"appType"];
    [SVProgressHUD showWithStatus:@"" maskType:SVProgressHUDMaskTypeGradient];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            [SVProgressHUD dismiss];
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                if ([PARSE_APP_LANGUAGE isEqualToString:@"Vi"]) {
                    NSString *appType = [[object valueForKey:@"appType" ] stringByReplacingOccurrencesOfString:@" " withString:@""];
                    if ([appType isEqualToString:@"app"]) {
                        [arrApp addObject:object];
                        
                    }else{
                        [arrGame   addObject:object];
                    }
                }else{
                    if ([[object valueForKey:@"appLanguage"]isEqualToString:@"Eng"]) {
                        NSString *appType = [[object valueForKey:@"appType" ] stringByReplacingOccurrencesOfString:@" " withString:@""];
                        if ([appType isEqualToString:@"app"]) {
                            [arrApp addObject:object];
                            
                        }else{
                            [arrGame   addObject:object];
                        }
                    }
                }
                
               
                
            }
          
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}



@end
