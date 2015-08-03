
#import "ImageDownloader.h"


@implementation ImageDownloader

@synthesize folderArray;
@synthesize delegate;

static ImageDownloader *imageDownloader = nil;

+(ImageDownloader *)instance
{
    if (imageDownloader == nil)
        imageDownloader = [[ImageDownloader alloc] init];
    
	return imageDownloader;
}

//=================this function will create folders for different images.'.' sign will keep the folder hidden=====
-(void)createFolderForImages:(NSString*)_folderName
{
	
 	NSError *error;
    NSString *folderPath = [self getFolderPath:_folderName];
    //NSLog(@"folderPath=%@",folderPath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
}
//==================================================================================================================

-(NSString *)getFolderPath:(NSString *)_folderName
{
	NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *documentDirectory=[path objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:folderName];
}

//===========================this function will delete all the folders created for saving images====================
-(void)deleteDirectoryForImages:(NSString *)_folderName
{
	NSError *error;
	NSString *folderPath = [self getFolderPath:_folderName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:folderPath error:&error];
    }
}

-(BOOL)downloadAndStoreImages:(NSString *)_imageUrl folderName:(NSString *)_folderName
{
	BOOL success=NO;
	NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@",[self getFolderPath:_folderName],[_imageUrl lastPathComponent]];
	if(![[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
	{
		UIImage *myImage=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageUrl]]];

		if (myImage)
		{ 
			//NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(myImage, 1.0f)] ;
			NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(myImage)];
			[data1 writeToFile:imageFilePath atomically:YES];
			success=YES;
		}
	}
	return success;
}


-(BOOL)downloadAndReplaceImage:(NSString *)_imageUrl folderName:(NSString *)_folderName
{
	BOOL success=NO;
	NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@",[self getFolderPath:_folderName],[_imageUrl lastPathComponent]];
	
	UIImage *myImage=[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString: _imageUrl]]];
	if(myImage)
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
		{
			if ([[NSFileManager defaultManager] removeItemAtPath:imageFilePath error:nil])
			{
				//NSLog(@"file removed ...");
			}
		}
	}
			
	/*
	if([[NSFileManager defaultManager] fileExistsAtPath:imageFilePath])
	{
		//NSLog(@"file exist " );
	}
	 */
	if (myImage)
	{ 
		NSData *data1 = [NSData dataWithData:UIImageJPEGRepresentation(myImage, 1.0f)] ;
		//NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(myImage)];
		if ([data1 writeToFile:imageFilePath atomically:YES]) {
			//NSLog(@"file saved ... %@",imageFilePath);
		}
		success=YES;
	}
		
	return success;
}





-(UIImage *)getImageFromFolder:(NSString *)imageUrl folderName:(NSString *)_folderName
{
	if([[imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0)
	{
		//NSString *imagePathUrl=[NSString stringWithFormat:@"%@",imageUrl];
		NSString *imageFilePath = [NSString stringWithFormat:@"%@/%@",[self getFolderPath:_folderName],[imageUrl lastPathComponent]];
		//NSLog(@"getImagePath = %@",path);
		UIImage *_image=[UIImage imageWithContentsOfFile:imageFilePath];
		
       // //NSLog(@"size = %@", NSStringFromCGSize(_image.size));
        
		if (_image)
		{
			return _image;
        }
        else
		{
			return nil;//[UIImage imageNamed:@"default_img.png"];
		}
	}		
	else
	{
		return nil;//[UIImage imageNamed:@"default_img.png"];
	}
}


//===================================================================================================================

-(void)downloadImageInBackground:(NSString *)_url folderObj:(NSString *)_folderName indicatorView:(UIView *)_view rowIndex:(int )_index
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        [self downloadAndStoreImages:_url folderName:_folderName];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            if([delegate respondsToSelector:@selector(downloadComplete:rowIndex:)])
                [delegate downloadComplete:_view rowIndex:_index];
            
        });
    });
}

//===================================================================================================================


@end
