//
//  ViewController.m
//  MSPYEPSeedingClient
//
//  Created by Le Thai Phuc Quang on 4/29/15.
//  Copyright (c) 2015 QuangLTP. All rights reserved.
//

#import "ViewController.h"
#import <ParseOSX/ParseOSX.h>
#import <CHCSVParser.h>
#import "PQEvent.h"

@interface ViewController()
@property (weak) IBOutlet NSTextField *nameTextField;
@property (weak) IBOutlet NSTextField *organizerTextField;
@property (weak) IBOutlet NSTextField *addressTextField;
@property (weak) IBOutlet NSTextField *websiteTextField;
@property (weak) IBOutlet NSDatePicker *fromDatePicker;
@property (weak) IBOutlet NSDatePicker *toDatePicker;
@property (weak) IBOutlet NSTextField *descriptionTextField;
@property (weak) IBOutlet NSImageView *mainImageView;

@property (strong, nonatomic) NSURL *csvUrl;

@property (strong, nonatomic) NSURL *imgUrl;

@property (strong, nonatomic) NSMutableArray *resultArray;

@property (strong, nonatomic) PQEvent *currentEvent;

@property NSInteger count;

@property (strong, nonatomic) NSArray *imgUrls;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupClickEventForImageView];
    _nameTextField.stringValue = @"test name";
    _organizerTextField.stringValue = @"test organizer";
    _addressTextField.stringValue = @"test address";
    _websiteTextField.stringValue = @"test website";
    _descriptionTextField.stringValue = @"test description";
    // Do any additional setup after loading the view.
}

- (void)setupClickEventForImageView {
    NSClickGestureRecognizer *clickGesture = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(imageClickEvent:)];
    [_mainImageView addGestureRecognizer:clickGesture];
    [_mainImageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)imageClickEvent:(NSClickGestureRecognizer *)regconizer {
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:YES];
    //[panel setAllowedFileTypes:[NSImage imageTypes]];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            _imgUrls = [panel URLs];
            //_csvUrl = [panel URL];
        }
    }];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    if(object == _mainImageView && [keyPath isEqualToString:@"image"])
    {
        // image changed, do anything your want
        
    }
}

- (IBAction)sendButton_TUI:(id)sender {
    PFQuery *eventQuery = [PFQuery queryWithClassName:@"Event"];
    [eventQuery whereKey:@"codeName" equalTo:@"hackathon"];
    [eventQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object,  NSError *error) {
        
        PFQuery *usersQuery = [PFQuery queryWithClassName:@"_User"];
        [usersQuery whereKey:@"codeName" notEqualTo:@"ltpquang"];
        [usersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            for (int i = 0; i < 15; ++i) {
                //NSString *fileName = [@(i+1) stringValue];
                //NSImage * image = [NSImage imageNamed:fileName];
                //NSBitmapImageRep *imgRep = [[image representations] objectAtIndex: 0];
                NSData *data = [NSData dataWithContentsOfURL:[_imgUrls objectAtIndex:i]];
                
                PFFile *file = [PFFile fileWithName:[NSString stringWithFormat:@"%@_%@.jpeg", (PFUser *)objects[i], [object objectId]] data:data];
                
                [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    PFObject *joiningInfo = [PFObject objectWithClassName:@"JoiningInfo"];
                    joiningInfo[@"user"] = (PFUser *)objects[i];
                    joiningInfo[@"event"] = object;
                    joiningInfo[@"picture"] = file;
                    [joiningInfo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        NSLog(@"Completed %i", i);
                    }];
                }
                                  progressBlock:^(int percentDone) {
                                      
                                      NSLog(@"%i - %i", i, percentDone);
                                  }];
            }
            
        }];
        
    }];
    /*
    CHCSVParser *parser = [[CHCSVParser alloc] initWithContentsOfCSVURL:_csvUrl];
    [parser setSanitizesFields:YES];
    parser.delegate = self;
    
    [parser parse];
    */
    
    /*
    PFFile *imageFile = [PFFile fileWithName:[_imgUrl lastPathComponent] data:[NSData dataWithContentsOfURL:_imgUrl]];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error) {
        if (succeeded) {
            //
            PFObject *eventObject = [PFObject objectWithClassName:@"Event"];
            eventObject[@"name"] = _nameTextField.stringValue;
            eventObject[@"image"] = imageFile;
            eventObject[@"description"] = _descriptionTextField.stringValue;
            eventObject[@"address"] = _addressTextField.stringValue;
            eventObject[@"organizer"] = _organizerTextField.stringValue;
            eventObject[@"website"] = _websiteTextField.stringValue;
            eventObject[@"fromDate"] = _fromDatePicker.dateValue;
            eventObject[@"toDate"] = _toDatePicker.dateValue;
            
            [eventObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *PF_NULLABLE_S error){
                if (succeeded) {
                    //
                }
                else {
                    //
                }
            }];
        }
        else {
            
        }
    }];
     */
}

- (void)parserDidBeginDocument:(CHCSVParser *)parser {
    _resultArray = [[NSMutableArray alloc] init];
    
}

- (void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber {
    _currentEvent = [[PQEvent alloc] init];
}

- (void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex {
    switch (fieldIndex) {
        case 0: //no
            //
            break;
        case 1: //name
            [_currentEvent setName:field];
            break;
        case 2: //codeName
            [_currentEvent setCodeName:field];
            break;
        case 3: //description
            [_currentEvent setEventDescription:field];
            break;
        case 4: //location
            [_currentEvent setLocation:field];
            break;
        case 5: //address
            [_currentEvent setAddress:field];
            break;
        case 6: //organizer
            [_currentEvent setOrganizer:field];
            break;
        case 7: //organizerLogo
            [_currentEvent setOrganizerLogo:field];
            break;
        case 8: //website
            [_currentEvent setWebsite:field];
            break;
        case 9: //image
            [_currentEvent setImage:field];
            break;
        case 10: //fromDate
            break;
        case 11: //toDate
            break;
        default:
            break;
    }
}

- (void)parser:(CHCSVParser *)parser didEndLine:(NSUInteger)recordNumber {
    [_resultArray addObject:_currentEvent];
}

- (void)parserDidEndDocument:(CHCSVParser *)parser {
    [_resultArray removeObjectAtIndex:0];
    _count = 0;
    for (PQEvent *event in _resultArray) {
        NSLog(@"Seeding item #%ld", _count + 1);
        [event uploadEventToServerWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                NSLog(@"Seeded item #%ld", _count + 1);
                ++_count;
                
                if (_count == _resultArray.count) {
                    //
                }
            }
        }];
    }
    //seed array
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
