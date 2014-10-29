//
//  PersonView.m
//  manpower
//
//  Created by Brian on 14-6-25.
//  Copyright (c) 2014年 WHZM. All rights reserved.
//

#import "PersonView.h"

@implementation PersonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.backImageView = [[UIImageView alloc] init];
//        self.backImageView = self.backImageView;
        self.backgroundColor = [UIColor grayColor];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 60, self.frame.size.height/2 - 40, 100, 40)];
        self.xmpp = [XMPPManager sharedInstance];

        [self.headImageView setImage:[self configImage]];
        [self addSubview:self.headImageView];
        self.jidLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 60, self.frame.size.height/2 , 100, 10)];
        self.jidLabel.textAlignment = NSTextAlignmentCenter;
        self.jidLabel.textColor = [UIColor blackColor];
        self.jidLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:self.jidLabel];
    }
    return self;
}

-(UIImage *)configImage
{
    XMPPvCardTemp *card = [self.xmpp.xmppvCardTempModule myvCardTemp];
    UIImage *photoImage;
    if (card.photo != nil) {
        photoImage = [UIImage imageWithData:card.photo];
    }else{
        NSData *photoData = [self.xmpp.xmppvCardAvatarModule photoDataForJID:card.jid];
        if (photoData != nil)
			photoImage =[UIImage imageWithData:photoData] ;
		else
			photoImage = [UIImage imageNamed:@"defaultPerson"];
    }
    
    return photoImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
