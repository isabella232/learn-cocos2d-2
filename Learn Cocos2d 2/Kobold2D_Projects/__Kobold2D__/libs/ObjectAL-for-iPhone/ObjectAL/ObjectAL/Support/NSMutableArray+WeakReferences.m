//
//  MutableArray-WeakReferences.m
//
//  Created by Karl Stenerud on 05/12/09.
//

#import "NSMutableArray+WeakReferences.h"
#import "kkARCSupport.h"

@implementation NSMutableArray (WeakReferences)

+ (id) newMutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity
{
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
	return (id)(CFArrayCreateMutable(0, (CFIndex)capacity, &callbacks));
}

+ (id) newMutableArrayUsingWeakReferences
{
	return [self newMutableArrayUsingWeakReferencesWithCapacity:0];
}

+ (id) mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger) capacity
{
    id result = [self newMutableArrayUsingWeakReferencesWithCapacity:capacity];
#if !__has_feature(objc_arc)
    [result autorelease];
#endif
    return result;
}

+ (id) mutableArrayUsingWeakReferences
{
	return [self mutableArrayUsingWeakReferencesWithCapacity:0];
}

@end

#define FIX_CATEGORY_BUG(name) @interface FIX_CATEGORY_BUG_##name @end @implementation FIX_CATEGORY_BUG_##name @end


FIX_CATEGORY_BUG(NSMutableArray_WeakReferences);
