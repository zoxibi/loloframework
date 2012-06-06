package game.module.testScene.view
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.core.BitmapMovieClip;
	import lolo.core.Scene;
	import lolo.events.BitmapMovieClipEvent;

	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		/**单例的实例*/
		public static var instance:TestScene;
		
		public var sndBtn:Button;
		
		public var soundPop:SoundPop = new SoundPop();
		
		
		private var _data:TestSceneData;
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			
			sndBtn.addEventListener(MouseEvent.CLICK, sndBtn_clickHandler);
		}
		
		private var _d:Array = [];
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			//soundPop.showOrHide();
			
			var bmd:BitmapData = new BitmapData(1000, 1000);
			_d.push(bmd);
		}
		//
	}
}