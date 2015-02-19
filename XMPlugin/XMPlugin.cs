using AppKit;

namespace XMPlugin
{
	public static class Plugin
	{
		public static void Hello ()
		{
			new NSAlert {
				MessageText = "Hello from Xamarin.Mac Plugin!"
			}.RunModal ();
		}
	}
}