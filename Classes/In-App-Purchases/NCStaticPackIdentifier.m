//
//  NCStaticPackIdentifier.m
//  NakedChinese
//
//  Created by IMAC  on 23.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "NCStaticPackIdentifier.h"


@implementation NCStaticPackIdentifier
+ (NSString *) getProductIdentifierByPackID:(int) packID
{
    //slang
    if(packID == 19)
    {
        return @"com.nakedchineseapp.nakedchinese.slang1";
    }
    //swear
    else if(packID == 20)
    {
        return @"com.nakedchineseapp.nakedchinese.swear1";
    }
    //sex - 2
    else if(packID == 18)
    {
        return @"com.nakedchineseapp.nakedchinese.sex2";
    }
    else
        return @"";
}

+ (NCPack *) getPackByProductIdentifier:(NSString *) identifier
{
    NCPack *pack = [[NCPack alloc] init];
    
    //slang
    if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.slang1"])
    {
        pack.partition = @"slang";
        pack.ID = @19;
    }
    //swear
    else if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.swear1"])
    {
        pack.partition = @"swear";
        pack.ID = @20;
    }
    //sex - 2
    if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.sex2"])
    {
        pack.partition = @"sex";
        pack.ID = @18;
    }

    return pack;
}
@end
