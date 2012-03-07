package game.module.testScene.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import reign.common.Common;
	import reign.components.Alert;
	import reign.components.Button;
	import reign.components.ComboBox;
	import reign.components.List;
	import reign.components.Page;
	import reign.components.RichText;
	import reign.components.ScrollBar;
	import reign.core.BitmapMovieClip;
	import reign.core.Scene;

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
		public var cb:ComboBox;
		
		public var richText:RichText;
		
		private var _alert:Alert;
		
		private var _data:TestSceneData;
		
		private var _c:Sprite;
		
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			
			var btn:Button;
			
			btn = new Button();
			btn.styleName = "button1";
			btn.label = "背景1";
			btn.width = 90;
			btn.x = 100;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK, test);
			this.addChild(btn);
			
			btn = new Button();
			btn.styleName = "button1";
			btn.label = "背景2";
			btn.width = 90;
			btn.x = 200;
			btn.y = 100;
			btn.addEventListener(MouseEvent.CLICK, test);
			this.addChild(btn);
			
			
			btn = new Button();
			btn.styleName = "button1";
			btn.label = "音效1";
			btn.width = 90;
			btn.x = 100;
			btn.y = 150;
			btn.addEventListener(MouseEvent.CLICK, test);
			this.addChild(btn);
			
			btn = new Button();
			btn.styleName = "button1";
			btn.label = "音效2";
			btn.width = 90;
			btn.x = 200;
			btn.y = 150;
			btn.addEventListener(MouseEvent.CLICK, test);
			this.addChild(btn);
			
			btn = new Button();
			btn.styleName = "button1";
			btn.label = "音效3";
			btn.width = 90;
			btn.x = 300;
			btn.y = 150;
			btn.addEventListener(MouseEvent.CLICK, test);
			this.addChild(btn);
			
			
			
			_mc = new BitmapMovieClip("testScene.TestMovieClip", 3);
			_mc.x = 50;
			_mc.y = 300;
			this.addChild(_mc);
		}
		
		private var _mc:BitmapMovieClip;
		
		
		private function test(event:Event):void
		{
			var btn:Button = event.currentTarget as Button;
			switch(btn.label)
			{
				case "背景1":
					Common.sound.play("background", "1", true);
					_mc.sourceName = "testScene.TestMovieClip2";
					break;
				
				case "背景2":
					Common.sound.play("background", "2", true);
					_mc.play(11, 2, 10);
					break;
				
				
				case "音效1":
					Common.sound.play("fight", "att1");
					_mc.dispose();
					break;
				
				case "音效2":
					Common.sound.play("fight", "lose", false, true, 1, false);
					_mc.gotoAndStop(2);
					break;
				
				case "音效3":
					Common.sound.play("fight", "win");
					_mc.playing ? _mc.stop() : _mc.play();
					break;
			}
		}
		//
	}
}