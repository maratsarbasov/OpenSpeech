//
//  ATMObject.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "AbstractObject.h"

@interface ATMObject : AbstractObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) CLLocation *location;

@end
