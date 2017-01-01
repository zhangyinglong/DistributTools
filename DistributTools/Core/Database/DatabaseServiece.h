//
//  DatabaseServiece.h
//  DistributTools
//
//  Created by zhangyinglong on 16/1/16.
//  Copyright © 2016年 ChinaHR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalMacro.h"
#import "SynthesizeSingleton.h"
#import "Database.h"

@interface DatabaseServiece : Database

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(DatabaseServiece);

- (void)runMigrations;

- (NSUInteger)databaseVersion;

- (void)setDatabaseVersion:(NSUInteger)newVersionNumber;

- (instancetype)initWithMigrations;

- (instancetype)initWithMigrations:(BOOL)loggingEnabled;

@end
