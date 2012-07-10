package
{
	import apps.CommonAppState;
	import apps.ILoadApplications;
	
	import camera.CameraModel;
	import camera.ICameraController;
	import camera.LookAtCameraController;
	
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import infrastructure.Requires;
	
	import lighting.GlobalLightValues;
	
	import maths.LatLongAltitude;
	import maths.Units;
	
	import scene.WorldMeshUpdater;
	
	import sceneNodes.SceneRoot;
	
	import streaming.StreamingController;
	import streaming.StreamingVolume;
	
	public class APP_NAMEAppApplicationModel
	{
		[Inject]
		public var stage:Stage;
		
		[Inject]
		public var applicationService:ILoadApplications;
		
		[Inject]
		public var streamingVolume:StreamingVolume;
		
		[Inject]
		public var streamingController:StreamingController;
		
		[Inject]
		public var renderer : APP_NAMEAppRenderer;
		
		[Inject]
		public var sceneRoot:SceneRoot;
		
		[Inject] 
		public var camController:ICameraController;
		
		[Inject]
		public var cameraModel:CameraModel;
		
		[Inject]
		public var worldMeshUpdater:WorldMeshUpdater;
		
		private const DEFAULT_LOOK_AT_LATITUDE:Number = 51.514431;
		private const DEFAULT_LOOK_AT_LONGITUDE:Number = -0.080262;
		private const DEFAULT_LOOK_AT_DISTANCE:Number = 990;
		private const DEFAULT_LOOK_AT_ALTITUDE:Number = 2.7;
		private const DEFAULT_HEADING_DEGREES:Number = 0;
		
		public function start(myState:Object, previousAppState:Object) : void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			var lookAtCamController:LookAtCameraController = camController as LookAtCameraController;
			Requires.notNull(lookAtCamController);
			
			if (previousAppState[CommonAppState.CAMERA_LOCATION] != undefined &&
				previousAppState[CommonAppState.CAMERA_LOOK_AT] != undefined)
			{
				var cameraLookAt:Vector3D = previousAppState[CommonAppState.CAMERA_LOOK_AT] as Vector3D;
				var cameraLocation:Vector3D = previousAppState[CommonAppState.CAMERA_LOCATION] as Vector3D;
				
				var interestLocation:Vector3D = (previousAppState[CommonAppState.INTEREST_LOCATION] != undefined)
					? (previousAppState[CommonAppState.INTEREST_LOCATION] as Vector3D)
					: cameraLookAt;
				
				if (previousAppState[CommonAppState.CAMERA_USER_PITCH] != undefined)
				{
					var userPitch:Number = previousAppState[CommonAppState.CAMERA_USER_PITCH] as Number;
					lookAtCamController.setUserTargetPitch(userPitch);
					lookAtCamController.setFromCameraLocationAndInterest(cameraLocation, interestLocation, false);
				}
				else
				{
					lookAtCamController.setFromCameraLocationAndInterest(cameraLocation, interestLocation, true);
				}
			}
			else
			{
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
		}
		
		public function update(dtMilliseconds:Number):void
		{
			streamingVolume.updateStreamingVolume();
			streamingController.updateResources();
			
			worldMeshUpdater.update(dtMilliseconds);
			renderer.render();
		}
		
		public function end(state:Object):void
		{
			Requires.notNull(state);
			
			state[CommonAppState.CAMERA_LOCATION] = cameraModel.worldPosition;
			state[CommonAppState.CAMERA_LOOK_AT] = cameraModel.earthLookAtPosition;
			
			var lookAtCamController:LookAtCameraController = camController as LookAtCameraController;
			Requires.notNull(lookAtCamController);
			
			state[CommonAppState.INTEREST_LOCATION] = lookAtCamController.interestLocationECEF;
			state[CommonAppState.CAMERA_USER_PITCH] = lookAtCamController.userTargetPitch;
			
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);	
		}
		
		public function closeApp():void
		{
			applicationService.loadDefaultApplication();
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				closeApp();
			}
		}
	}
}
