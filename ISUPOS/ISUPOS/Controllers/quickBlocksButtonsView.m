//
//  quickBlocksButtonsView.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 5/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "quickBlocksButtonsView.h"
#import "language.h"
@interface quickBlocksButtonsView ()
{
    NSMutableArray *articleNames,*articleNamesForSave,*articleImages,*articleDisplayName;
    NSMutableDictionary *indexdata;
    UIView *popview;
    NSString *abc;
    int articlecount;
    int keyboard;
    NSString *currencySign;
    UITableView * poptable;
    BOOL filterArticle;
    NSMutableArray *farticlenames;
    NSMutableArray *farticleImages;
    
    CGFloat	animatedDistance;
    
}

@property (nonatomic, strong) UIPopoverController *popOver;
@end

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 160;

@implementation quickBlocksButtonsView
@synthesize callBack,isEdit,str_id;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    blockName.placeholder=[Language get:@"Name" alter:@"!Name"];
     blockArticle.placeholder=[Language get:@"Article Number" alter:@"!Article Number"];
    title1.text=[Language get:@"Quick Button/Blocks" alter:@"!Quick Button/Blocks"];

    
    [self getAllArticles];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context save:&error];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        currencySign=[matches valueForKey:@"currency"];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}
- (void)keyboardDidShow: (NSNotification *) notif{
    keyboard=1;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    keyboard=0;
}
-(void)viewWillAppear:(BOOL)animated
{
    [CAncel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [Save_Button setTitle:[Language get:@"Save" alter:@"!Save"] forState:UIControlStateNormal];

    self.view.superview.layer.cornerRadius = 0;
    
    
    if (isEdit==YES) {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"QuickBlocks" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",str_id];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];

    NSManagedObject *newContact = (NSManagedObject *)[objects objectAtIndex:0];
        
        
    abc=@"";
    NSString *str_Name;
        
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        
        abc=[person valueForKey:@"quick_article_nos"];
        
        NSArray *listItems = [abc componentsSeparatedByString:@","];
        
        [person valueForKey:@"quick_article_nos"];
        [person valueForKey:@"id"];
        str_Name=[person valueForKey:@"name"];
        
        articleNamesForSave=[[NSMutableArray alloc]init];
        
        for (int i=0; i<[listItems count]; i++) {
            [indexdata setValue:@"yes" forKey:listItems[i]];
            [articleNamesForSave addObject:listItems[i]];
        }
        
    }
        
        abc=[abc stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        if ([abc hasPrefix:@","]) {
            abc = [abc substringFromIndex:1];
        }
        
        blockArticle.text=abc;
        blockName.text=str_Name;
    
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)toCancelAndSaveBtn:(UIButton*)sender
{
    if(sender.tag==2)
    {
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }
    }
    else if (sender.tag==3)
    {
        if ([blockName.text isEqualToString:@""] || [blockArticle.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter block title and article no." alter:@"!Please enter block title and article no."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            if (isEdit==YES) {
            [self EditQuickBlock];
            }
            else
            {
            [self saveQuickBlock];
            }
        }
        
    }
}
-(void)saveQuickBlock
{
        NSString *abcd=@"";
        for(int i=0;i<articleNamesForSave.count;i++)
        {
             abcd=[NSString stringWithFormat:@"%@,%@",abcd,articleNamesForSave[i]];
        }
        abcd=[abcd stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
        if ([abcd hasPrefix:@","])
        {
            abcd = [abcd substringFromIndex:1];
        }

        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"QuickBlocks" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"QuickBlocks" inManagedObjectContext:context];
        [newContact setValue:[NSNumber numberWithInt:(int)objects.count+1] forKey:@"id"];
        [newContact setValue:abcd forKey:@"quick_article_nos"];
        [newContact setValue:blockName.text forKey:@"name"];
        [context save:&error];

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Data saved." alter:@"!Data saved."]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
    [callBack performSelector:@selector(toDismissThePopover)];
}


-(void)EditQuickBlock
{
    
    NSString *abcd=@"";
    for(int i=0;i<articleNamesForSave.count;i++)
    {
        abcd=[NSString stringWithFormat:@"%@,%@",abcd,articleNamesForSave[i]];
    }
    abcd=[abcd stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    if ([abcd hasPrefix:@","])
    {
        abcd = [abcd substringFromIndex:1];
    }
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"QuickBlocks" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",str_id];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"QuickBlocks" inManagedObjectContext:context];
    NSManagedObject *newContact = (NSManagedObject *)[objects objectAtIndex:0];
//    [newContact setValue:[NSNumber numberWithInt:(int)objects.count+1] forKey:@"id"];
    [newContact setValue:abcd forKey:@"quick_article_nos"];
    [newContact setValue:blockName.text forKey:@"name"];
    [context save:&error];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Data saved." alter:@"!Data saved."]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
    [callBack performSelector:@selector(toDismissThePopover)];
    
}


-(void)toDismissThePopover
{
    
}
-(void)getAllArticles
{
    articleNames = [[NSMutableArray alloc] init];
    
    indexdata = [[NSMutableDictionary alloc] init];
    
    articleImages = [[NSMutableArray alloc] init];
    
    articleDisplayName=[[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:entityDesc];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for(int i = 0;i < objects.count; i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];

        [articleNames addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"article_no"]]?[person valueForKey:@"article_no"]:@""];
        [articleDisplayName addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"name"]]?[person valueForKey:@"name"]:@""];
        
//        [articleNames addObject:[person valueForKey:@"article_no"]];
//        [articleDisplayName addObject:[person valueForKey:@"name"]];
        NSData *da=[person valueForKey:@"article_img_url"];
        
        if (da != nil && da.length>0)
        {
            UIImage *img=[[UIImage alloc] initWithData:da];
            [articleImages addObject:img];
        }
        else
        {
            UIImage *img = [UIImage new];
            [articleImages addObject:img];
        }
        
        
        
    }
}


#pragma mark - UITextField Delegates

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"animate" context:nil];
    
    [UIView setAnimationDuration:0.35f];
    
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:@"animate" context:nil];

    [UIView setAnimationDuration:0.35f];
    
    [UIView setAnimationBeginsFromCurrentState: NO];
    
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    if(textField.tag == 234)
    {
        if(keyboard==0)
        {
        [blockName resignFirstResponder];
        [blockArticle resignFirstResponder];
        popview = [[UIView alloc]initWithFrame:CGRectMake(00, 180, self.view.frame.size.width,self.view.frame.size.height-180)];

        popview.backgroundColor=[UIColor clearColor];
        
        
        UIView *popvieww = [[UIView alloc]initWithFrame:CGRectMake(31, 115, 505,40)];
            
            UISearchBar *searchId_bar = [[UISearchBar alloc]initWithFrame:CGRectMake(120, 3, 260, 30)];
            searchId_bar.backgroundColor = [UIColor whiteColor];
            searchId_bar.placeholder = [NSString stringWithFormat:@"%@", [Language get:@"Search Article" alter:@"!Search Article"]];
            
            searchId_bar.delegate = self;
            
            [popvieww addSubview:searchId_bar];
            
        
        popvieww.backgroundColor=[UIColor lightGrayColor];
        
        [popview addSubview:popvieww];
        
        
        UIButton *uim = [[UIButton alloc]initWithFrame:CGRectMake(443, 117, 120, 38)];
        
        uim.tag = 1100;
        
        [uim setTitle:[Language get:@"Done" alter:@"!Done"] forState:UIControlStateNormal];
        
        [uim setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [uim addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *popview1 = [[UIView alloc]initWithFrame:CGRectMake(31, 155, 505,160)];
        
        popview1.backgroundColor=[UIColor whiteColor];
        
        popview1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        popview1.layer.borderWidth=1.0;
        
        poptable=[[UITableView alloc]initWithFrame:CGRectMake(-10, 10, 505, 150) style:UITableViewStylePlain];
        
        poptable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        poptable.tag=2;
        
        poptable.dataSource=self;
        
        poptable.delegate=self;
        
        poptable.backgroundColor=[UIColor clearColor];
        
        [poptable setBackgroundView:nil];
        
        poptable.separatorColor=[UIColor lightGrayColor];
        
        [popview1 addSubview:poptable];
        
        [popview addSubview:popview1];
        
        [popview addSubview:uim];
        
        [self.view addSubview:popview];
        
        return NO;
        }
        else
        {
            [blockName resignFirstResponder];
            [blockArticle resignFirstResponder];
            return NO;
        }
        
    }
    return YES;
}
-(void)buttonclick:(UIButton*)but
{
    if(but.tag==1100)
    {
        filterArticle=NO;
        
     
            
            abc=@"";
            articleNamesForSave=[[NSMutableArray alloc]init];
            for(int i=0;i<articleNames.count;i++)
            {
                
                if([[indexdata valueForKey:articleNames[i] ] isEqualToString:@"yes"])
                {
                    abc=[NSString stringWithFormat:@"%@,%@",abc,articleNames[i]];
                    [articleNamesForSave addObject:articleNames[i]];
                    
                }
                
            }
            
            abc=[abc stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if ([abc hasPrefix:@","]) {
                abc = [abc substringFromIndex:1];
            }
            
            
            blockArticle.text=abc;
            
            [popview removeFromSuperview];
            
        
        
        
    }
    
    else
    {
        
        if (filterArticle) {
        
        
        if([[but imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"Tick-ico.png"]])
        {
            [but setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
            [indexdata setValue:@"no" forKey:farticlenames[but.tag]];
            articlecount--;
        }
        else
        {
            [but setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
            [indexdata setValue:@"yes" forKey:farticlenames[but.tag]];
            articlecount++;
        }
        }
        else
        {
            if([[but imageForState:UIControlStateNormal]isEqual:[UIImage imageNamed:@"Tick-ico.png"]])
            {
                [but setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
                [indexdata setValue:@"no" forKey:articleNames[but.tag]];
                articlecount--;
            }
            else
            {
                [but setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
                [indexdata setValue:@"yes" forKey:articleNames[but.tag]];
                articlecount++;
            }
        }
        
    }
    
    
}
#pragma mark Table View Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (filterArticle) {
        return farticlenames.count;
    }
    else
    {
    return articleNames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    if (filterArticle) {
        
        UIButton *uim=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
        uim.tag=indexPath.row ;
        if([[indexdata valueForKey:farticlenames[indexPath.row] ] isEqualToString:@"yes"])
            [uim setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
        else
            [uim setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
        
        [uim addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView =uim;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor clearColor];
        
        UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 40, 40)];
        img1.backgroundColor=[UIColor grayColor];
        img1.image=articleImages[indexPath.row];
        [cell addSubview:img1];
        
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (80, 15, 150, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:farticlenames[indexPath.row]];
        img1.image=farticleImages[indexPath.row];
        [cell addSubview:label];

    }
    else
    {
    
    UIButton *uim=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 45, 45)];
    uim.tag=indexPath.row ;
    if([[indexdata valueForKey:articleNames[indexPath.row] ] isEqualToString:@"yes"])
        [uim setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
    else
        [uim setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
    
    [uim addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView =uim;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(25, 5, 40, 40)];
    img1.backgroundColor=[UIColor grayColor];
    img1.image=articleImages[indexPath.row];
    [cell addSubview:img1];
    
    
    UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
    CGRect labelFrame = CGRectMake (80, 15, 150, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setFont:myFont];
    label.lineBreakMode=NSLineBreakByWordWrapping;
    label.numberOfLines=5;
    label.textColor=[UIColor grayColor];
    label.backgroundColor=[UIColor clearColor];
    [label setText:articleNames[indexPath.row]];
    [cell addSubview:label];
    }

    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


#pragma mark - UISearchBar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    CGRect textFieldRect = [self.view.window convertRect:searchBar.bounds fromView:searchBar];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)string
{
    
    
    string=[string lowercaseString];
    
    if([string isEqualToString:@""])
    {
        filterArticle=NO;
    }
    else
    {
        filterArticle=YES;
    }

    farticlenames = [[NSMutableArray alloc]init];
    farticleImages = [[NSMutableArray alloc]init];
    
    for(int i=0;i<articleNames.count;i++)
    {
        if ([[articleNames[i] lowercaseString] rangeOfString:string].location == NSNotFound &&[[articleDisplayName[i] lowercaseString] rangeOfString:string].location == NSNotFound) {
            
        }
        else
        {
           
            [farticlenames addObject:articleNames[i]];
            [farticleImages addObject:articleImages[i]];
            
        }
        [poptable reloadData];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    UITextInputAssistantItem* item = [searchBar inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    return YES;
}
@end
