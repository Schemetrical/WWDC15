//
//  PHLibraryManager.m
//  Pixel
//
//  Created by Yichen Cao on 3/30/15.
//  Copyright (c) 2015 schemetrical. All rights reserved.
//

#import <Photos/Photos.h>
#import "PHLibraryManager.h"

typedef void (^FetchAlbumCompletionHandler)(PHAssetCollection *album);

@implementation PHLibraryManager

+ (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumName errorHandler:(void (^)(NSError *error))errorHandler {
    void (^fetchAlbumCompletionHandler)(PHAssetCollection *album) = ^(PHAssetCollection *album) {
        [self writeImage:image toAlbum:album errorHandler:errorHandler];
    };
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [PHLibraryManager fetchAlbum:albumName completionHandler:fetchAlbumCompletionHandler errorHandler:errorHandler];
            } else {
                errorHandler([NSError errorWithDomain:PHContentEditingInputErrorKey code:0 userInfo:@{@"error" : @"no access"}]);
            }
        }];
    } else {
        [PHLibraryManager fetchAlbum:albumName completionHandler:fetchAlbumCompletionHandler errorHandler:errorHandler];
    }
}

+ (void)fetchAlbum:(NSString *)albumName completionHandler:(FetchAlbumCompletionHandler)completionHandler errorHandler:(void (^)(NSError *error))errorHandler { // Assumed at this point that you are authorised
    // Create new album if no albums.
    NSString *albumID = [[NSUserDefaults standardUserDefaults] valueForKey:@"albumID"];
    PHFetchResult *albums;
    
    if (albumID) {
        albums = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumID] options:nil];
    }
    if (!albums.count || !albumID) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName];
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                errorHandler(error);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                                     subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                                     options:nil];
                    for (PHAssetCollection *collection in albums) {
                        if ([collection.localizedTitle isEqualToString:albumName]) {
                            [[NSUserDefaults standardUserDefaults] setValue:collection.localIdentifier forKey:@"albumID"];
                            completionHandler(collection);
                            return;
                        }
                    }
                });
            }
        }];
    } else {
        completionHandler(albums[0]);
    }
}

+ (void)writeImage:(UIImage *)image toAlbum:(PHAssetCollection *)album errorHandler:(void (^)(NSError *error))errorHandler {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];
        [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            errorHandler(error);
        }
    }];
}

@end
