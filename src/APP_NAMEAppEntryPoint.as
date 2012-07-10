package
{
	import flash.display.Sprite;
	import apps.IEntryPoint;
	
	public class APP_NAMEAppEntryPoint extends Sprite implements IEntryPoint
	{
		public function getApplication() : Class
		{
			return APP_NAMEAppApplicationModule
		}
	}
}