package
{
	import apps.ApplicationModule;
	import ui.commonHud.cameraControls.LookAtCameraModule;
	
	public class APP_NAMEAppApplicationModule extends ApplicationModule
	{
		override protected function onRegister() : void
		{
			addChildModule(LookAtCameraModule);
			
			injector.mapSingleton(APP_NAMEAppApplicationModel);
			injector.mapSingleton(APP_NAMEAppRenderer);
			
			addUpdateableType(APP_NAMEAppApplicationModel);
		}
		
		override protected function onUnregister() : void
		{
			removeUpdateableType(APP_NAMEAppApplicationModel);
			
			injector.unmap(APP_NAMEAppRenderer);
			injector.unmap(APP_NAMEAppApplicationModel);	
			
			removeChildModule(LookAtCameraModule);
		}
		
		override protected function applicationStart(myState:Object, previousAppState:Object) : void
		{
			var app : APP_NAMEAppApplicationModel = injector.getInstance(APP_NAMEAppApplicationModel) as APP_NAMEAppApplicationModel;
			app.start(myState, previousAppState);
		}
		
		override protected function applicationEnd():Object 
		{
			var app:APP_NAMEAppApplicationModel = injector.getInstance(APP_NAMEAppApplicationModel) as APP_NAMEAppApplicationModel;
			return app.end();
		}
	}
}
