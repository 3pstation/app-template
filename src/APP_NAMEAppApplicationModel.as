package
{
	import camera.ICameraController;
	import camera.LookAtCameraController;
	import infrastructure.Requires;
	import maths.LatLongAltitude;
	import maths.Units;
	import scene.WorldMeshUpdater;
	import streaming.StreamingController;
	import streaming.StreamingVolume;
	
	public class APP_NAMEAppApplicationModel
	{				
		[Inject]
		public var streamingVolume:StreamingVolume;
		
		[Inject]
		public var streamingController:StreamingController;
		
		[Inject]
		public var renderer : APP_NAMEAppRenderer;
				
		[Inject] 
		public var camController:ICameraController;
				
		[Inject]
		public var worldMeshUpdater:WorldMeshUpdater;
		
		private const DEFAULT_LOOK_AT_LATITUDE:Number = 51.514431;
		private const DEFAULT_LOOK_AT_LONGITUDE:Number = -0.080262;
		private const DEFAULT_LOOK_AT_DISTANCE:Number = 990;
		private const DEFAULT_LOOK_AT_ALTITUDE:Number = 2.7;
		private const DEFAULT_HEADING_DEGREES:Number = 0;
		
		public function start(myState:Object, previousAppState:Object) : void
		{			
			var lookAtCamController:LookAtCameraController = camController as LookAtCameraController;
			Requires.notNull(lookAtCamController);
		
			var defaultLookAtLocation:LatLongAltitude = new LatLongAltitude(
				DEFAULT_LOOK_AT_LATITUDE, 
				DEFAULT_LOOK_AT_LONGITUDE, 
				DEFAULT_LOOK_AT_ALTITUDE, 
				Units.DEGREES);
			
			lookAtCamController.setInterestHeadingDistance(
				defaultLookAtLocation, 
				DEFAULT_HEADING_DEGREES, 
				DEFAULT_LOOK_AT_DISTANCE);			
		}
		
		public function update(dtMilliseconds:Number):void
		{
			streamingVolume.updateStreamingVolume();
			streamingController.updateResources();
			
			worldMeshUpdater.update(dtMilliseconds);
			renderer.render();
		}
		
		public function end():Object
		{
			return new Object();
		}
	}
}
