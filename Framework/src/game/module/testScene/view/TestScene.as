package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.core.Scene;
	import lolo.utils.TimeUtil;

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
			Common.stage.addEventListener(MouseEvent.CLICK, stage_mouseDownHandler, true, 222);
			Common.stage.addEventListener(MouseEvent.CLICK, test, true, 111);
			
			var t:int = 5.11 * 24 * 60 * 60 * 1000;
			trace(TimeUtil.format(t, "ms", "", "", "", "", false, true));
		}
		
		private function test(event:MouseEvent):void
		{
			trace("test");
		}
		
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			trace("ok!");
			event.stopPropagation();
//			event.stopImmediatePropagation();
		}
		
		
		
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			soundPop.showOrHide();
		}
		//
	}
}