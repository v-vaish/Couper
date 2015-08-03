

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ImageDownloaderDelegate

-(void)downloadComplete:(UIView *)_indicatorView rowIndex:(int)_index;

@end


@interface ImageDownloader : NSObject 
{
	NSString *folderName;

}

@property (nonatomic,retain) NSMutableArray *folderArray;
@property (nonatomic,strong) id delegate;

+(ImageDownloader *)instance;
-(void)createFolderForImages:(NSString*)_folderName;
-(void)deleteDirectoryForImages:(NSString *)_folderName;
-(BOOL)downloadAndStoreImages:(NSString *)_imageUrl folderName:(NSString *)_folderName;
-(BOOL)downloadAndReplaceImage:(NSString *)_imageUrl folderName:(NSString *)_folderName;
-(UIImage *)getImageFromFolder:(NSString *)imageUrl folderName:(NSString *)_folderName;
-(void)downloadImageInBackground:(NSString *)_url folderObj:(NSString *)_folderName indicatorView:(UIView *)_view rowIndex:(int )_index;
@end
