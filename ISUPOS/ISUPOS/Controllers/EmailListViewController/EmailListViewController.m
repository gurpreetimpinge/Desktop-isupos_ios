//
//  EmailListViewController.m
//  ISUPOS
//
//  Created by MacUser on 3/30/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import "EmailListViewController.h"
#import "AppDelegate.h"
#import "Language.h"
#import "Reachability.h"
#import "UITextField+Validations.h"

@interface EmailListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    AppDelegate *appDelegate;
    
    IBOutlet UINavigationItem *emails;
    IBOutlet UITableView *tbl_EmailList;
    IBOutlet UIButton *btn_Email;
    
    NSMutableArray *ary_EmailList;
    
    int int_SelectedIndex;
}

@end

@implementation EmailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
    
    [[UINavigationBar appearance] setFrame:CGRectMake(0, 0, 1024, 64)];
    
    int_SelectedIndex = -1;
    ary_EmailList = [NSMutableArray new];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"EmailList" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc2];
    
    NSArray *objects2 = [context executeFetchRequest:request error:nil];
    NSManagedObject *matches = nil;
    
    [ary_EmailList removeAllObjects];
    
    for(int i=0;i<[objects2 count];i++)
    {
        matches=(NSManagedObject*)[objects2 objectAtIndex:i];
        [ary_EmailList addObject:[matches valueForKey:@"emailId"]];
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"] isEqualToString:[matches valueForKey:@"emailId"]])
        {
            int_SelectedIndex = i;
        }
        
    }
    
    [tbl_EmailList reloadData];
    
    
    emails.title = [Language get:@"Emails" alter:@"!Emails"];
    
    // Do any additional setup after loading the view.
}

- (IBAction)backButton_Action:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnMailAction:(UIButton *)sender {
    
    if([ary_EmailList count]>0)
    {
        [self createEmailTextfile];
    }
    
    
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
//    if (internetStatus != NotReachable) {
//        
//        UIAlertView *alertViewEmail=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        alertViewEmail.alertViewStyle=UIAlertViewStylePlainTextInput;
//        alertViewEmail.tag=104;
//        [alertViewEmail show];
//    }
//    else {
//        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }
    
}


-(void)createEmailTextfile
{
    NSString *str_EmailList=[[NSString alloc]init];
    
    for (int i=0; i<[ary_EmailList count]; i++)
    {
        str_EmailList = [str_EmailList stringByAppendingString:[NSString stringWithFormat:@"%@\n",[ary_EmailList objectAtIndex:i]]];
        
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[paths objectAtIndex:0]);
       
    NSString *path = [NSString stringWithFormat:@"%@/Email.txt",[paths objectAtIndex:0]];
    
    [str_EmailList writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    
    [[AppDelegate delegate] sendEmailListAttachmentMail:data];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 104) {
        if (buttonIndex == 0) {
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Repo" forKey:@"MailType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *email = [alertView textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self createEmailTextfile];
              //  [[AppDelegate delegate] sendLogDetailMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
            }
            
        }
    }
}


#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ary_EmailList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil) {
        cell = nil;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *lbl_Email = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, tbl_EmailList.frame.size.width-90, 48)];
    lbl_Email.text = [ary_EmailList objectAtIndex:indexPath.row];
    lbl_Email.textColor = [UIColor blackColor];
    lbl_Email.backgroundColor = [UIColor whiteColor];
    lbl_Email.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    [cell.contentView addSubview:lbl_Email];
    
    
    UIButton *btn_SelectedEmail = [[UIButton alloc]initWithFrame:CGRectMake(tbl_EmailList.frame.size.width-50-20, 10, 48, 48)];
    if (int_SelectedIndex == indexPath.row)
    {
        [btn_SelectedEmail setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btn_SelectedEmail setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
    }
    [btn_SelectedEmail addTarget:self action:@selector(emailSelected:) forControlEvents:UIControlEventTouchUpInside];
    btn_SelectedEmail.tag = indexPath.row;
    [cell.contentView addSubview:btn_SelectedEmail];
    
    
    UILabel *lbl_Underline = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl_Email.frame)+1, tbl_EmailList.frame.size.width, 1)];
    lbl_Underline.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lbl_Underline];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

-(void)emailSelected:(UIButton *)sender
{
    if (sender.tag == int_SelectedIndex)
    {
        int_SelectedIndex = -1;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"EMAIL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        int_SelectedIndex = (int)sender.tag;
        
        NSString *email = [ary_EmailList objectAtIndex:sender.tag];
        [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    [tbl_EmailList reloadData];
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

@end
