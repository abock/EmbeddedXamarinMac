//
//  ViewController.m
//  EmbeddedXamarinMac
//
//  Created by Aaron Bockover on 2/13/15.
//  Copyright (c) 2015 Xamarin. All rights reserved.
//

#import "ViewController.h"

#include <xamarin.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)runSomeCSharp:(id)sender {
	MonoAssembly *pluginAssembly = xamarin_open_and_register ("XMPlugin.dll");
	MonoImage *pluginImage = mono_assembly_get_image (pluginAssembly);
	MonoClass *pluginClass = mono_class_from_name (pluginImage, "XMPlugin", "Plugin");
	MonoMethod *helloMethod = mono_class_get_method_from_name (pluginClass, "Hello", 0);
	
	void *params[0];
	mono_runtime_invoke (helloMethod, NULL, params, NULL);
}
@end