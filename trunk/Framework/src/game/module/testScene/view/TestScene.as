package game.module.testScene.view
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import reign.common.Common;
	import reign.components.List;
	import reign.components.Page;
	import reign.components.ScrollBar;
	import reign.core.Scene;
	import reign.data.HashMap;

	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		/**单例的实例*/
		public static var instance:TestScene;
		
		public var list:List;
		public var page:Page;
		public var vsb:ScrollBar;
		public var hsb:ScrollBar;
		
		
		public function TestScene()
		{
			super();
			instance = this;
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
//			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			list.itemRendererClass = TestItem;
			list.selectMode = List.SELECT_MODE_KEY;
			list.page = page;
			
			var timer:Timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			timer.start();
			timerHandler(null);
		}
		
		
		private function timerHandler(event:TimerEvent):void
		{
			var add:Boolean;
			
			var data:HashMap = new HashMap();
//			for(var i:int = 0; i < Math.random() * 10 + 20; i++)
			for(var i:int = 0; i < 200; i++)
			{
				data.add(i, "aa" + i, "bb" + i);
				
				if(!add && Math.random() * 30 > 28) {
					data.add(999, "99d");
					add = true;
				}
			}
			list.data = data;
			
			vsb.update();
			hsb.update();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			
		}
		//
	}
}