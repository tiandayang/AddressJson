//
//  ViewController.m
//  AddressJson
//
//  Created by 田向阳 on 2017/11/14.
//  Copyright © 2017年 田向阳. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    NSString *_lastCountry;
    NSString *_lastCity;
    NSMutableArray *_dataArray;
    NSMutableDictionary *_countryDic;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
- (IBAction)analysis:(id)sender {
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/address.json"];
//#error 请把 ‘tianxiangyang’换成你们对应的用户名  修改完成 在模拟器运行点击解析，桌面就会生成一个json文件 就可以直接拿来用了
    NSString *path = @"/Users/tianxiangyang/Desktop/address.json";
    NSLog(@"%@",path);
    _countryDic = [NSMutableDictionary dictionary];
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"]];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (array) {
        _dataArray = [self configData:[NSMutableArray arrayWithArray:array]];
//        NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
        NSMutableArray *resultArray = [NSMutableArray array];
        [_countryDic.mutableCopy enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *tempArray = [self cityDictionary:[self allCityInCountry:key]];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:key forKey:@"name"];
            [dic setObject:tempArray forKey:@"city"];
            [resultArray addObject:dic];
        }];
        NSString *jsonStr = [self dictionaryToJson:@{@"data": resultArray}];
        [jsonStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

#pragma mark - 解析
//字典转json
- (NSString *)dictionaryToJson:(NSDictionary *)dic
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = @"";
    
    if (! jsonData){
        NSLog(@"Got an error: %@", error);
    }else{
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
}


/**
  归并某个二级下的所有内容
 */
- (NSMutableArray *)cityDictionary:(NSArray *)array
{
    NSMutableArray *cityArray = array.lastObject;
    NSMutableArray *cityNameArray = array.firstObject;
    NSMutableArray *resultArray = [NSMutableArray array];
    [cityNameArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *townArray = [NSMutableArray array];
        NSMutableDictionary *cityDic = [NSMutableDictionary dictionary];
        for (NSArray *subArray in cityArray) {
            NSString *city = subArray[1];
            if ([city isEqualToString:obj]) {
                [townArray addObject:subArray[2]];
                [cityDic setObject:obj forKey:@"name"];
                [cityDic setObject:townArray forKey:@"country"];
            }
        }
        if (cityDic.count > 0) {
            [resultArray addObject:cityDic];
        }
    }];
    return  resultArray;
}
//处理源数据 使每一组数据都能够对应起来
- (NSMutableArray *)configData:(NSMutableArray *)array
{
    for (NSArray *subArray in array.mutableCopy) {
        NSMutableArray *mArray = [NSMutableArray arrayWithArray:subArray];
        NSString *country = subArray[0];
        NSString *city = subArray[1];
        if (country.length > 0) {
            _lastCountry = country;
            [_countryDic setObject:@"" forKey:country];
        }else{
            [mArray replaceObjectAtIndex:0 withObject:_lastCountry];
        }
        if (city.length > 0) {
            _lastCity = city;
        } else {
            [mArray replaceObjectAtIndex:1 withObject:_lastCity];
        }
        NSInteger index = [array indexOfObject:subArray];
        [array replaceObjectAtIndex:index withObject:mArray];
    }
    return array;
}
//某个省下的所有城市
- (NSMutableArray *)allCityInCountry:(NSString *)province
{
    NSMutableArray *cityArray = [NSMutableArray array];
    NSMutableArray *cityNameArray = [NSMutableArray array];
    for (NSArray *array in _dataArray) {
        NSString *countryStr = array[0];
        NSString *city = array[1];
        if ([countryStr isEqualToString:province]) {
            [cityArray addObject:array];
        }
        if (![cityNameArray containsObject:city]) {
            [cityNameArray addObject:city];
        }
    }
    
    return  @[cityNameArray,cityArray].mutableCopy;
}

@end
