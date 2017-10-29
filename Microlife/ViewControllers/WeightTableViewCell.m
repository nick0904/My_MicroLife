//
//  WeightTableViewCell.m
//  Microlife
//
//  Created by Rex on 2016/9/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "WeightTableViewCell.h"

@implementation WeightTableViewCell

@synthesize noteBase,typeImage,decorateLine,timeLabel,weightValue,BMIValue,bodyFatValue,waterValue,skeletonValue,muscleValue,BMRValue,organFatVlaue,noteTextView,cellImage,recordView,middeleDetail,bottomDetail,topDetail;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WeightTableViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        
        if (arrayOfViews.count < 1)
            
            return nil;
        
        // 如果xib中view不属于UICollectionViewCell类，return nil
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
            
            return nil;
        
        // NSLog(@"arrayOfViews  %i",arrayOfViews.count);
        
        // 加载nib
        
        self = [arrayOfViews objectAtIndex:0];
        
        
        self.hasImage = NO;
        self.hasRecord = NO;
        self.showDetail = YES;
        initLayOut = YES;
        noteTextView.editable = NO;
        noteTextView.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect cellRect = self.bounds;
    cellRect.size.width = self.frame.size.width;
    
    if (initLayOut) {
        
        initLayOut = NO;
        
        if (!self.hasImage && !self.hasRecord) {
            cellImage.frame = CGRectMake(cellImage.frame.origin.x, cellImage.frame.origin.y, 0, 0);
            
            recordView.frame = CGRectMake(recordView.frame.origin.x, recordView.frame.origin.y, 0, 0);
            
            recordView.hidden = YES;
            
            noteTextView.frame = CGRectMake(0, 0, noteBase.frame.size.width, noteBase.frame.size.height);
        }
        
        if (self.hasRecord && !self.hasImage) {
            
            cellImage.frame = CGRectMake(cellImage.frame.origin.x, cellImage.frame.origin.y, 0, 0);
            
            recordView.frame = CGRectMake(cellImage.frame.origin.x, 5, recordView.frame.size.width, noteBase.frame.size.height-10);
        }
        
        if (!self.hasRecord && self.hasImage) {
            
            cellImage.frame = CGRectMake(cellImage.frame.origin.x, cellImage.frame.origin.y, cellImage.frame.size.width, cellImage.frame.size.height);
            
            recordView.frame = CGRectMake(cellImage.frame.origin.x, cellImage.frame.origin.y, 0, 0);
            
            recordView.hidden = YES;
        }
    }
    
    
    if(self.showDetail){
        
        middeleDetail.hidden = NO;
        bottomDetail.hidden = NO;
        
        noteBase.frame = CGRectMake(noteBase.frame.origin.x, bottomDetail.frame.origin.y+bottomDetail.frame.size.height+10, noteBase.frame.size.width, noteBase.frame.size.height);
        
        //cellRect.size.height = cellRect.size.height+middeleDetail.frame.size.height+bottomDetail.frame.size.height;
        
    }else{
        
        noteBase.frame = CGRectMake(noteBase.frame.origin.x, topDetail.frame.origin.y+topDetail.frame.size.height+10, noteBase.frame.size.width, noteBase.frame.size.height);
        
        //cellRect.size.height = cellRect.size.height-middeleDetail.frame.size.height-bottomDetail.frame.size.height;
        
        
        middeleDetail.hidden = YES;
        bottomDetail.hidden = YES;
        
    }
    
    self.bounds = cellRect;
    
}

- (IBAction)moreBtnAction:(id)sender {
    
    NSLog(@"%d",self.showDetail);
    
    NSLog(@"noteBase.frame.size.height = %f",noteBase.frame.size.height);
    
    if (self.showDetail) {
        [self.moreBtn setImage:[UIImage imageNamed:@"history_icon_a_more_up"] forState:UIControlStateNormal];
    }else{
        [self.moreBtn setImage:[UIImage imageNamed:@"history_icon_a_more_down"] forState:UIControlStateNormal];
    }
    
    self.showDetail = !self.showDetail;
    
    [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
