package
{
	import apps.IEntryPoint;
	import flash.display.Sprite;
	
	public class APP_NAMEAppEntryPoint extends Sprite implements IEntryPoint
	{
		public function getApplication() : Class
		{
			return APP_NAMEAppApplicationModule
		}
	}
}