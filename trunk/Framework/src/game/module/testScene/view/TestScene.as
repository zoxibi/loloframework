package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.components.Label;
	import lolo.core.Scene;
	import lolo.data.LastTime;
	import lolo.utils.RTimer;
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
		
		private var _label:Label;
		private var _time:LastTime;
		private var _timer:RTimer = RTimer.getInstance(1000, timerHandler);
		private var _timer2:RTimer = RTimer.getInstance(1000, timerHandler);
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			
			sndBtn.addEventListener(MouseEvent.CLICK, sndBtn_clickHandler);
			
			
			_label = new Label();
			_label.x = _label.y = 50;
			_label.size = 14;
			this.addChild(_label);
		}
		
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			_time = new LastTime(10, "s");
			_timer.start();
			timerHandler();
		}
		
		
		private function timerHandler():void
		{
			var time:int = _time.getTime();
			trace(time);
			_label.text = TimeUtil.format(time);
		}
		//
	}
}