//
//  main.m
//  EmbeddedXamarinMac
//
//  Created by Aaron Bockover on 2/13/15.
//  Copyright (c) 2015 Xamarin. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#include <xamarin.h>

// this is missing from Xamarin.Mac's mono-runtime.h
extern void mono_set_assemblies_path (const char *path);

int
main (int argc, const char **argv)
{
	// Load the Mono symbols from the linked libmono dylib, Mono APIs
	// can now be used from Xamarin.Mac's mono-runtime.h, which is
	// included by xamarin.h
	xamarin_initialize_dynamic_runtime (NULL);

	// EmbeddedXamarinMac.app/Contents/MonoBundle
	const char *monoBundlePath = xamarin_get_bundle_path ();

	// Configure search paths for the Mono runtime
	mono_set_dirs (monoBundlePath, monoBundlePath);
	mono_set_assemblies_path (monoBundlePath);

	// Enable debug symbol loading
	mono_debug_init (MONO_DEBUG_FORMAT_MONO);

	// Read machine.config and register it with the Mono runtime
	NSString *machineConfigPath = [[NSString stringWithUTF8String:monoBundlePath]
		stringByAppendingPathComponent:@"machine.config"];

	NSString *machineConfig = [NSString
	 stringWithContentsOfFile:machineConfigPath
	 encoding:NSUTF8StringEncoding
	 error:NULL];

	if (machineConfig)
		mono_register_machine_config ([machineConfig UTF8String]);
	else
		fprintf (stderr, "WARNING: no machine.config in bundle: `%s'\n",
			[machineConfigPath UTF8String]);

	// Initialize the Mono JIT
	mono_jit_init_version ("EmbeddedXamarinMac", "v4.0.0.0");

	// Initialize the native Xamarin.Mac runtime
	xamarin_initialize ();

	// Initialize the managed Xamarin.Mac runtime
	MonoAssembly *xammacAssembly = xamarin_open_and_register ("Xamarin.Mac.dll");
	MonoImage *xammacImage = mono_assembly_get_image (xammacAssembly);
	MonoClass *nsapplicationClass = mono_class_from_name (xammacImage, "AppKit", "NSApplication");
	MonoMethod *initMethod = mono_class_get_method_from_name (nsapplicationClass, "Init", 0);
	void *initParams[0];
	mono_runtime_invoke (initMethod, NULL, initParams, NULL);

	return NSApplicationMain (argc, argv);
}