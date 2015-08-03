//
//  Utils.m
//  Couper
//
//  Created by Vinay on 18/03/15.
//  Copyright (c) 2015 Couper. All rights reserved.
//

#import <MBProgressHUD.h>
#import "Utils.h"
#import "CustomPickerView.h"
#import <AddressBookUI/AddressBookUI.h>
#import <NBPhoneNumberUtil.h>


@implementation Utils


+ (void)showIndicatorView:(UIView *)_view
{
    [MBProgressHUD showHUDAddedTo:_view animated:YES];
}

+ (void)hideIndicatorView:(UIView *)_view
{
    [MBProgressHUD hideHUDForView:_view animated:YES];
}

+ (void)alert:(NSString *)_msg
{
    UIAlertView *messageAlert = [[UIAlertView alloc] initWithTitle:@"Couper" message:_msg delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
    
    [messageAlert show];
}

+(BOOL)isCameraAvailable
{
    BOOL _status = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    return _status;
}

+(void)openCamera:(id)_selfRef
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = _selfRef;
    [_selfRef presentViewController:imagePicker animated:YES completion:nil];
}

+(void)getPhotoFromGallary:(id)_selfRef
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [imagePicker setDelegate:_selfRef];
    [_selfRef presentViewController:imagePicker animated:YES completion:nil];
}

+ (void)makeCircleImage:(UIImageView *)_imageView
{
    _imageView.layer.cornerRadius = _imageView.frame.size.width / 2;
    _imageView.clipsToBounds = YES;
    _imageView.layer.borderWidth = 0.0f;

}

+ (void)makeCircleButton:(UIButton *)_button
{
    _button.layer.cornerRadius = _button.frame.size.width / 2;
    _button.clipsToBounds = YES;
    _button.layer.borderWidth = 0.0f;

}

+(void)setImageAsColor:(UIImage *)_image view:(UIView *)_currentView
{
    UIGraphicsBeginImageContext(_currentView.frame.size);
    [_image drawInRect:_currentView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _currentView.backgroundColor = [UIColor colorWithPatternImage:image];
}

+(CGSize)getVideoResolution:(NSString *)_videoPath
{
    AVAssetTrack *videoTrack = nil;
    AVURLAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_videoPath]];
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    CMFormatDescriptionRef formatDescription = NULL;
    NSArray *formatDescriptions = [videoTrack formatDescriptions];
    if ([formatDescriptions count] > 0)
        formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
    
    if ([videoTracks count] > 0)
        videoTrack = [videoTracks objectAtIndex:0];
    
    CGSize trackDimensions = {
        .width = 0.0,
        .height = 0.0,
    };
    trackDimensions = [videoTrack naturalSize];
    
    int width = trackDimensions.width;
    int height = trackDimensions.height;
    //NSLog(@"Resolution = %d X %d",width ,height);
    
    return CGSizeMake(width, height);
    
}

+(UIImage *)thumbNail:(NSURL *)_localFileUrl
{
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:_localFileUrl options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    
    int64_t value = 1;
    int32_t preferredTimeScale = 2;
    CMTime time = CMTimeMake(value, preferredTimeScale);
    
    //CMTime time = CMTimeMake(1, 2);
    CGImageRef oneRef = [generate1 copyCGImageAtTime:time actualTime:NULL error:&err];
    UIImage *one = [[UIImage alloc] initWithCGImage:oneRef];
    
    return one;
}


+ (UIImage *)convertViewInImage:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+(NSTimeInterval)differenceTwoDate:(NSString *)startDate endDate:(NSString *)endDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //For TEsting
    
   // startDate = @"2015-04-20 17:30:30";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [df setTimeZone:gmt];
    
    NSDate *date1 = [df dateFromString:startDate];
    NSDate *date2 = [df dateFromString:endDate];
    
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    
    float numberOfDays = secondsBetween / 86400;
    
    //NSLog(@"There are %f days in between the two dates.", numberOfDays);
    
    
    return secondsBetween;
}

+ (NSString *)getTimeRepresentationForDate:(NSString *)date{
    
    NSString *aReturnValue = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [dateFormatter dateFromString:date];
    
    if ([endDate compare:[NSDate date]] == NSOrderedAscending) {
        return @"Expired";
    }
    
    unsigned int theUnits = NSCalendarUnitDay | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar *aCalender = [NSCalendar currentCalendar];
    NSDateComponents *aDateComponents = [aCalender components:theUnits fromDate:[NSDate date] toDate:endDate options:0];
    
    NSString *days    = nil;
    NSString *hours   = nil;
    NSString *minutes = nil;
    NSString *seconds = nil;
    
    if ([aDateComponents day] < 10)
        days = [NSString stringWithFormat:@"0%ld",[aDateComponents day]];
    else
        days = [NSString stringWithFormat:@"%ld",[aDateComponents day]];
    
    if ([aDateComponents hour] < 10)
        hours = [NSString stringWithFormat:@"0%ld",[aDateComponents hour]];
    else
        hours = [NSString stringWithFormat:@"%ld",[aDateComponents hour]];
    if ([aDateComponents minute] < 10)
        minutes = [NSString stringWithFormat:@"0%ld",[aDateComponents minute]];
    else
        minutes = [NSString stringWithFormat:@"%ld",[aDateComponents minute]];
    if ([aDateComponents second] < 10)
        seconds = [NSString stringWithFormat:@"0%ld",[aDateComponents second]];
    else
        seconds = [NSString stringWithFormat:@"%ld",[aDateComponents second]];
    
    aReturnValue = [NSString stringWithFormat:@"%@:%@:%@:%@", days, hours, minutes, seconds];
    
    return aReturnValue;
}

+(void)playSound:(NSString *)_fileName type:(NSString *)_type
{
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:_fileName ofType:_type];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
}



+ (BOOL) isContactAccessGranted
{
    __block BOOL accessGranted = NO;
    CFErrorRef *error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    return  accessGranted ;
}


+ (NSArray *)getAllContacts
{
    NSMutableArray *arrContact = [NSMutableArray array];
    CFErrorRef error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    
    if (addressBook != nil)
    {
        
        NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        for (NSUInteger i = 0; i < [allContacts count]; i++)
        {
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
            if ([firstName length] == 0) {
                firstName = @"";
            }
            NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
            if ([lastName length] == 0) {
                lastName = @"";
            }
            NSString *fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            //email
            ABMultiValueRef phoneNumbers = ABRecordCopyValue(contactPerson,kABPersonPhoneProperty);
            NSString *phone = @"";
            if (ABMultiValueGetCount(phoneNumbers) > 0) {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
                phone = (__bridge_transfer NSString *) phoneNumberRef;
            }
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if ([phone length] > 0 && ([firstName length] > 0 || [lastName length] > 0))
            {
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"  ()-+"];
                phone = [[phone componentsSeparatedByCharactersInSet:doNotWant] componentsJoinedByString:@""];

                /*
                phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
                phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
                */
                [dic setObject:fullName forKey:@"UserName"];
                [dic setObject:phone forKey:@"phone"];
                [arrContact addObject:dic];
            }
        }
        
        //NSLog(@"%@",arrContact);
        //7
        CFRelease(addressBook);
    }
    
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"UserName" ascending:YES selector:@selector(localizedCompare:)];
    NSArray* sortedArray = [arrContact sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];

    
    return sortedArray;
}

+ (BOOL)validateEmail:(NSString *)emailStr
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


+(BOOL)isSIMCardExist
{
    CTTelephonyNetworkInfo *networkInfo = [CTTelephonyNetworkInfo new];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    
    
    if (!carrier.isoCountryCode) {
        //NSLog(@"No sim present Or No cellular coverage or phone is on airplane mode.");
        return NO;
    }
    return YES;
}


+(BOOL)checkMobileNumberValidationByAPI:(NSString *)numberStr
{
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:numberStr
                                 defaultRegion:@"SG" error:&anError];
    
    return [phoneUtil isValidNumber:myNumber];
}



@end
