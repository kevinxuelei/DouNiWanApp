//
//  DNWWeatherDataHandle.m
//  DouNiWan
//
//  Created by HMT@WDQ on 14-5-13.
//  Copyright (c) 2014年 胡明涛. All rights reserved.
//

#define WeatherChina @"http://flash.weather.com.cn/wmaps/xml/china.xml"
#define WeatherPublicInterFace @"http://flash.weather.com.cn/wmaps/xml/"
#define WeatherXML   @".xml"

#define WeatherImageInterFace @"http://m.weather.com.cn/img/b"
#define WeatherGif            @".gif"


#import "DNWWeatherData.h"
#import <AddressBook/AddressBook.h>     // 导入对应库
#import <CoreLocation/CoreLocation.h>   // 导入对应库
#import "HMTMyCustomNetRequest.h"
#import "GDataXMLNode.h"


@interface DNWWeatherData (){

    /**
     *  2个网络请求对象
     */
    HMTMyCustomNetRequest * _request;
    HMTMyCustomNetRequest * _mutilpRequest;
    
    //  位置反编码对象
    CLGeocoder * _geocoder;

}

@end

@implementation DNWWeatherData

- (void)dealloc{
    
    RELEASE_SAFELY(_locationManage);
    RELEASE_SAFELY(_request);
    RELEASE_SAFELY(_mutilpRequest);
    RELEASE_SAFELY(_geocoder);
    Block_release(_passWeatherData);

    RELEASE_SAFELY(_temperatureLow);
    RELEASE_SAFELY(_temperatureHeight);
    RELEASE_SAFELY(_cityName);
    RELEASE_SAFELY(_cityNamePY);
    RELEASE_SAFELY(_stateDetailed);
    RELEASE_SAFELY(_windState);
    RELEASE_SAFELY(_stateImageUrl1);
    RELEASE_SAFELY(_stateImageUrl2);
    [super dealloc];

}

- (id)init{

    if (self = [super init]) {
        
#pragma mark - 地图GPS定位
        [self createGPSMap];
    }

    return self;
}

#pragma mark - 将汉字转换为不带音调的拼音(貌似中间有空格)
- (NSString *)transformMandarinToLatin:(NSString *)string
{
    
    NSMutableString *preString = [string mutableCopy];
    /*转换成成带音调的拼音*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformMandarinLatin, NO);
    /*去掉音调*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformStripDiacritics, NO);
    
    return preString;
}

#pragma mark - 获得特殊城市天气情况(4个直辖市,香港,澳门)
- (void)getAllSpecialCityWeatherInterFaceWithCityName:(NSString *)city{
    
    // 因为自动定位获得的city后面带了一个"市",但是接口里面的key没有
    NSString * cityFitXML = [city substringWithRange:NSMakeRange(0,2)];
    
    _request = [[HMTMyCustomNetRequest alloc] init];
    [_request requestForGETWithUrl:WeatherChina];
    __block DNWWeatherData * otherSelf = self;
    [_request setFinishLoadBlock:^(NSData * data){
    
        GDataXMLDocument * document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
        GDataXMLElement * rootXMLEl = [document rootElement];
        NSArray * cityArray = [rootXMLEl elementsForName:@"city"];
        for (int i = 27; i < [cityArray count]; i++) {
            
            GDataXMLElement * city = [cityArray objectAtIndex:i];
            otherSelf.cityName = [[city attributeForName:@"quName"] stringValue];
            otherSelf.cityNamePY = [[city attributeForName:@"pyName"] stringValue];
            otherSelf.stateDetailed = [[city attributeForName:@"stateDetailed"] stringValue];
            otherSelf.temperatureLow = [[city attributeForName:@"tem2"] stringValue];
            otherSelf.temperatureHeight = [[city attributeForName:@"tem1"] stringValue];
            otherSelf.windState = [[city attributeForName:@"windState"] stringValue];
            NSString * stateImage1 = [[city attributeForName:@"state1"] stringValue];
            NSString * stateImage2 = [[city attributeForName:@"state2"] stringValue];
            otherSelf.stateImageUrl1= [NSURL URLWithString:[[WeatherImageInterFace stringByAppendingString:stateImage1] stringByAppendingString:WeatherGif]];
            otherSelf.stateImageUrl2 = [NSURL URLWithString:[[WeatherImageInterFace stringByAppendingString:stateImage2] stringByAppendingString:WeatherGif]];
            
            if ([cityFitXML isEqualToString:otherSelf.cityName]) {
                
                if (otherSelf.passWeatherData) {
                    
                    otherSelf.passWeatherData(otherSelf);
                }
                
            }
            
        }
        
        [document release];
    }];
    
}

#pragma mark - 获得其余各地市的天气情况
- (void)getWeatherInterFaceWithCityName:(NSString *) city{
    
    //  因为自动定位获得的city后面带了一个"市",但是接口里面的key没有
    NSString * cityFitXML = [city substringWithRange:NSMakeRange(0,2)];
    
    //  创建网络请求对象
    _request = [[HMTMyCustomNetRequest alloc] init];
    _mutilpRequest = [[HMTMyCustomNetRequest alloc] init];
    
    //  __block修饰self,防止内存泄露
    __block DNWWeatherData * otherSelf = self;
    
    //  先请求全国所有省的天气状况,得到省会名字
    [_request requestForGETWithUrl:WeatherChina];
    [_request setFinishLoadBlock:^(NSData * data){
       
        GDataXMLDocument * provinceDocument = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
        GDataXMLElement * rootCountryXMLEl = [provinceDocument rootElement];
        NSArray * cityArray = [rootCountryXMLEl elementsForName:@"city"];
        
        // 利用得到的省会名,拼接访问各省天气的接口进行请求
        for (int i = 0; i < [cityArray count]; i++) {
            
            GDataXMLElement * province = [cityArray objectAtIndex:i];
            NSString * otherCityNamePY = [[province attributeForName:@"pyName"] stringValue];
            NSString * weatherCityInterFace = [[WeatherPublicInterFace stringByAppendingString:otherCityNamePY] stringByAppendingString:WeatherXML];
            
            [_mutilpRequest requestForGETWithUrl:weatherCityInterFace];
            [_mutilpRequest setFinishLoadBlock:^(NSData * data){
            
                GDataXMLDocument * cityDocument = [[GDataXMLDocument alloc] initWithData:data options:0 error:nil];
                GDataXMLElement * rootProvinceXMLEl = [cityDocument rootElement];
                NSArray * cityArrayInProvince = [rootProvinceXMLEl elementsForName:@"city"];
                for (int j = 0; j < [cityArrayInProvince count]; j++) {
                    
                    GDataXMLElement * city = [cityArrayInProvince objectAtIndex:j];
                    otherSelf.cityName = [[city attributeForName:@"cityname"] stringValue];
                    otherSelf.cityNamePY = [[city attributeForName:@"pyName"] stringValue];
                    otherSelf.stateDetailed = [[city attributeForName:@"stateDetailed"] stringValue];
                    otherSelf.temperatureLow = [[city attributeForName:@"tem2"] stringValue];
                    otherSelf.temperatureHeight = [[city attributeForName:@"tem1"] stringValue];
                    otherSelf.windState = [[city attributeForName:@"windState"] stringValue];
                    NSString * stateImage1 = [[city attributeForName:@"state1"] stringValue];
                    NSString * stateImage2 = [[city attributeForName:@"state2"] stringValue];
                    otherSelf.stateImageUrl1= [NSURL URLWithString:[[WeatherImageInterFace stringByAppendingString:stateImage1] stringByAppendingString:WeatherGif]];
                    otherSelf.stateImageUrl2 = [NSURL URLWithString:[[WeatherImageInterFace stringByAppendingString:stateImage2] stringByAppendingString:WeatherGif]];
                    
                    // 自动地位得到的城市,进行匹配,然后对View传入值赋值
                    if ([cityFitXML isEqualToString:otherSelf.cityName]) {
                        
                        if (otherSelf.passWeatherData) {
                            
                            otherSelf.passWeatherData(otherSelf);
                        }
                        
                    }
                    
                }
                [cityDocument release];
            
            }];
            
        }
        
        [provinceDocument release];
    
    }];

}


- (void)createGPSMap{
    
    // 初始化位置服务
    self.locationManage = [[CLLocationManager alloc]init];
    
    // 要求CLLocationManager对象返回全部信息
    _locationManage.distanceFilter = kCLDistanceFilterNone;
    
    // 设置定位精度
    _locationManage.desiredAccuracy = kCLLocationAccuracyBest;
    
    // 设置代理
    _locationManage.delegate = self;
    
    // 开始定位
    [_locationManage startUpdatingLocation];
    
    [_locationManage release];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation * newLocation = [locations lastObject];
    
    // 停止实时定位
    [_locationManage stopUpdatingLocation];
    
    
    // -----------------------位置反编码------------------------
     _geocoder = [[CLGeocoder alloc]init];
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * place in placemarks) {
            
#pragma mark - 使用系统定义的字符串直接查询,记得导入AddressBook框架
            
            // 获得省市名
            NSString * city = place.locality;
            
            // 北京,上海,重庆等是没有city属性的,这样做一个这样的判断
            if(city == nil)
            {
                city = place.addressDictionary[(NSString *)kABPersonAddressStateKey];
                [self getAllSpecialCityWeatherInterFaceWithCityName:city];
            }else{
            
                [self getWeatherInterFaceWithCityName:city];
            }
            
        }
        
    }];
    
}


@end





























