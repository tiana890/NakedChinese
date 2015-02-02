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
        return @"com.nakedchineseapp.nakedchinese.product.packslangone";
    }
    //swear
    else if(packID == 20)
    {
        return @"com.nakedchineseapp.nakedchinese.product.packswearone";
    }
    //sex - 2
    else if(packID == 18)
    {
        return @"com.nakedchineseapp.nakedchinese.product.packsex2";
    }
    else
        return @"";
}

+ (NCPack *) getPackByProductIdentifier:(NSString *) identifier
{
    NCPack *pack = [[NCPack alloc] init];
    
    //slang
    if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.product.packslangone"])
    {
        pack.partition = @"slang";
        pack.ID = @19;
    }
    //swear
    else if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.product.packswearone"])
    {
        pack.partition = @"swear";
        pack.ID = @20;
    }
    //sex - 2
    if([identifier isEqualToString:@"com.nakedchineseapp.nakedchinese.product.packsex2"])
    {
        pack.partition = @"sex";
        pack.ID = @18;
    }

    return pack;
}
@end
