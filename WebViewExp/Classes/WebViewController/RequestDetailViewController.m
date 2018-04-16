//
//  RequestDetailViewController.m
//  WebViewExp
//
//  Created by Bq Lin on 2018/4/14.
//  Copyright © 2018年 Bq. All rights reserved.
//

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "RequestDetailViewController.h"
#import <YYModel.h>
#import "NSString+Bq.h"
#import <Masonry.h>
#import "BqUtil.h"

static NSString *NSStringFromNSURLRequestCachePolicy(NSURLRequestCachePolicy cachePolicy) {
	switch (cachePolicy) {
		case NSURLRequestReloadIgnoringCacheData:{
			return @"NSURLRequestReloadIgnoringCacheData";
		} break;
		case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:{
			return @"NSURLRequestReloadIgnoringLocalAndRemoteCacheData";
		} break;
		case NSURLRequestReloadRevalidatingCacheData:{
			return @"NSURLRequestReloadRevalidatingCacheData";
		} break;
		case NSURLRequestReturnCacheDataDontLoad:{
			return @"NSURLRequestReturnCacheDataDontLoad";
		} break;
		case NSURLRequestReturnCacheDataElseLoad:{
			return @"NSURLRequestReturnCacheDataElseLoad";
		} break;
		case NSURLRequestUseProtocolCachePolicy:{
			return @"NSURLRequestUseProtocolCachePolicy";
		} break;
	}
}

static NSString *NSStringFromNSURLRequestNetworkServiceType(NSURLRequestNetworkServiceType networkServiceType) {
	switch (networkServiceType) {
		case NSURLNetworkServiceTypeBackground:{
			return @"NSURLNetworkServiceTypeBackground";
		} break;
		case NSURLNetworkServiceTypeCallSignaling:{
			return @"NSURLNetworkServiceTypeCallSignaling";
		} break;
		case NSURLNetworkServiceTypeDefault:{
			return @"NSURLNetworkServiceTypeDefault";
		} break;
		case NSURLNetworkServiceTypeVideo:{
			return @"NSURLNetworkServiceTypeVideo";
		} break;
		case NSURLNetworkServiceTypeVoice:{
			return @"NSURLNetworkServiceTypeVoice";
		} break;
		case NSURLNetworkServiceTypeVoIP:{
			return @"NSURLNetworkServiceTypeVoIP";
		} break;
	}
}

static const CGFloat BqFontSize = 14.0;

@interface RequestDetailViewController ()

@property (nonatomic, strong) UITextView *requestTextView;
@property (nonatomic, strong) NSArray *requstInfos;

@end

@interface NSMutableAttributedString (Bq)

- (void)appendString:(NSString *)aString;

@end

@implementation NSMutableAttributedString (Bq)

- (void)appendString:(NSString *)aString {
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:aString attributes:
  @{
	NSFontAttributeName: [UIFont systemFontOfSize:BqFontSize]
	}];
	[self appendAttributedString:attrString];
}

@end

@implementation RequestDetailViewController

#pragma mark - property

- (UITextView *)requestTextView {
	if (!_requestTextView) {
		_requestTextView = [[UITextView alloc] initWithFrame:CGRectZero];
		_requestTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
		_requestTextView.layer.cornerRadius = 4.0;
		_requestTextView.editable = NO;
		if (@available(iOS 11.0, *)) {
			_requestTextView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}
	}
	return _requestTextView;
}

- (void)setRequest:(NSURLRequest *)request {
	_request = request;
	
	//[descriptions addObject:@{@"": request.}];
	NSMutableArray *descriptions = [NSMutableArray array];
	[descriptions addObject:@{@"URL": request.URL.absoluteString}];
	[descriptions addObject:@{@"mainDocumentURL": request.mainDocumentURL.absoluteString}];
	[descriptions addObject:@{@"HTTPMethod": request.HTTPMethod}];
	NSString *HTTPBody = [NSString stringFromData:request.HTTPBody];
	[descriptions addObject:@{@"HTTPBody": HTTPBody}];
	[descriptions addObject:@{@"allHTTPHeaderFields": request.allHTTPHeaderFields}];
	[descriptions addObject:@"\n"];
	
	[descriptions addObject:@{@"timeoutInterval": [NSString stringWithFormat:@"%@s", @(request.timeoutInterval)]}];
	[descriptions addObject:@{@"HTTPShouldHandleCookies": request.HTTPShouldHandleCookies ? @"true" : @"false"}];
	[descriptions addObject:@{@"HTTPShouldUsePipelining": request.HTTPShouldUsePipelining ? @"true" : @"false"}];
	[descriptions addObject:@{@"allowsCellularAccess": request.allowsCellularAccess ? @"true" : @"false"}];
	[descriptions addObject:@"\n"];
	
	[descriptions addObject:@{@"cachePolicy": NSStringFromNSURLRequestCachePolicy(request.cachePolicy)}];
	[descriptions addObject:@{@"NSURLRequestNetworkServiceType": NSStringFromNSURLRequestNetworkServiceType(request.networkServiceType)}];
	
	_requstInfos = descriptions.copy;
}

#pragma mark - view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self setupUI];
}

- (void)setupUI {
	self.view.backgroundColor = [UIColor whiteColor];
	self.automaticallyAdjustsScrollViewInsets = NO;
	//self.title = self.request.URL.absoluteString.decodeUrl;
	self.title = @"请求详情";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
	UIButton *showActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[showActionBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
	[showActionBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
	[showActionBtn sizeToFit];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showActionBtn];
	[self.view addSubview:self.requestTextView];
	CGFloat xMargin = 16;
	CGFloat yMargin = 8;
	
#if Xcode9
	if (BQ_AVAILABLE(11)) {
		[self.requestTextView makeConstraints:^(MASConstraintMaker *make) {
			//make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
			make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(yMargin);
			make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-yMargin);
			make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(xMargin);
			make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-xMargin);
		}];
	} else {
		[self.requestTextView makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.mas_topLayoutGuide).offset(yMargin);
			make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-yMargin);
			make.left.equalTo(self.view).offset(xMargin);
			make.right.equalTo(self.view).offset(-xMargin);
		}];
	}
#else
	[self.requestTextView makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_topLayoutGuide).offset(yMargin);
		make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-yMargin);
		make.left.equalTo(self.view).offset(xMargin);
		make.right.equalTo(self.view).offset(-xMargin);
	}];
#endif
	
	self.requestTextView.attributedText = [self requestDescription];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)doneAction:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAction:(UIButton *)sender {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		[alertController dismissViewControllerAnimated:YES completion:^{}];
	}]];
	__weak typeof(self) weakSelf = self;
	[alertController addAction:[UIAlertAction actionWithTitle:@"复制" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		//NSData* jsonData =[NSJSONSerialization dataWithJSONObject:weakSelf.requstInfos options:NSJSONWritingPrettyPrinted error:nil];
		//NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = weakSelf.requestTextView.text;
	}]];
	if (IS_IPAD) {
		UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
		popPresenter.sourceView = sender;
		popPresenter.sourceRect = sender.bounds;
		popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
	}
	[self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - private

- (NSAttributedString *)requestDescription {
	NSMutableAttributedString *requestDescription = [[NSMutableAttributedString alloc] init];
	for (id info in self.requstInfos) {
		if ([info isKindOfClass:[NSDictionary class]]) {
			[requestDescription appendAttributedString:[self subInfos:info level:0]];
		} else {
			[requestDescription appendString:info];
		}
	}
	//NSLog(@"request: \n%@", requestDescription);
	return requestDescription;
}
- (NSAttributedString *)subInfos:(NSDictionary *)infos level:(int)level {
	NSMutableAttributedString *subInfo = [[NSMutableAttributedString alloc] init];
	for (id key in infos.allKeys) {
		id value = infos[key];
		for (int i = 0; i < level; i ++) {
			[subInfo appendString:@"\t"];
		}
		NSAttributedString *attriKeyString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", key] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:BqFontSize]}];
		[subInfo appendAttributedString:attriKeyString];
		if ([value isKindOfClass:[NSDictionary class]]) {
			[subInfo appendString:@"\n"];
			[subInfo appendAttributedString:[self subInfos:value level:level+1]];
		} else {
			[subInfo appendString:[NSString stringWithFormat:@"%@\n", value]];
		}
	}
	return subInfo;
}

@end
