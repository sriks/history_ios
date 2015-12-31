/*!
 Author: Srikanth
 History, August 2014
 **/

#import "THLinkedItemViewCell.h"
#import "THLinkedItemModel.h"
#import "DCTheme.h"
#import "THConstants.h"

@interface THLinkedItemViewCell ()
@property (nonatomic) NSURL* wikiURL;
@end

@implementation THLinkedItemViewCell

- (IBAction)onWikipediaButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:self.wikiURL];
}

- (void)configure:(THLinkedItemModel*)model {
    self.backgroundColor = [UIColor clearColor];
    self.wikiURL = model.wikiURL;
    self.title.font = [DCTheme fontForSubheading];
    self.content.font = [DCTheme fontForBody];
    
    self.title.text = model.title;
    self.content.text = model.content;
    self.wikiButton.enabled = (model.wikiURL != nil);
}

@end
