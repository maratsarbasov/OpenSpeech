//
//  ActionDecider.h
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YandexSpeechKit/YSKRecognition.h>

#import "ActionObjects.h"


@interface ActionDecider : NSObject

+ (AbstractAction *)decideForRecognition:(YSKRecognition *)recognition;

@end
