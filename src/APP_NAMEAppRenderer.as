package
{
	import lighting.GlobalLightValues;
	import rendering.IEegeoRenderer;
	import resources.sky.SkyController;	
	import camera.CameraModel;
		
	public class APP_NAMEAppRenderer
	{
		[Inject] 
		public var skyController:SkyController;
		
		[Inject]
		public var cameraModel:CameraModel;		
		
		[Inject] 
		public var renderer : IEegeoRenderer;
		
		[Inject]
		public var globalLightValues:GlobalLightValues;
		
		public function render():void
		{
			globalLightValues.dirty();
			skyController.updateSky(cameraModel.computeBasis());
			renderer.renderScene();
		}
	}
}