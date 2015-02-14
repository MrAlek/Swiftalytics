//
// SWAClassBlockStorage.m
//
// Created by Alek Åström on 2015-02-14.
// Copyright (c) 2015 Alek Åström. (https://github.com/MrAlek)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "SWAClassBlockStorage.h"
#import <objc/runtime.h>

@interface SWAClassBlockStorage ()
@property (nonatomic, strong) NSMapTable *mapTable;
@end

@implementation SWAClassBlockStorage

- (instancetype)init {
    self = [super init];
    if (self) {
        _mapTable = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsWeakMemory valueOptions:NSPointerFunctionsCopyIn];
    }
    return self;
}

- (void)setBlock:(MapBlock)block forClass:(id)klass {
    [self.mapTable setObject:block forKey:klass];
}
- (nullable MapBlock)blockForClass:(id)klass {
    MapBlock block = [self.mapTable objectForKey:klass];
    
    if (block) {
        return block;
    }
    
    Class superclass = class_getSuperclass(klass);
    
    if (superclass) {
        return [self blockForClass:(superclass)];
    }
    
    return nil; // ¯\_(ツ)_/¯
}

- (void)removeAllBlocks {
    [self.mapTable removeAllObjects];
}
- (void)removeBlockForClass:(id)klass {
    [self.mapTable removeObjectForKey:klass];
}

@end
