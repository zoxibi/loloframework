package game.module.testScene.view
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.components.ImageLoader;
	import lolo.components.ScrollBar;
	import lolo.core.Scene;

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
			
			
			var img:ImageLoader = new ImageLoader();
			img.path = "assets/{resVersion}/img/background/{0}.jpg";
			img.fileName = "1";
			var s:Sprite = new Sprite();
			s.addChild(img);
			this.addChild(s);
			
			_sb = new ScrollBar();
			_sb.styleName = "vScrollBar1";
			_sb.disArea = {x:100, y:100, width:200, height:200};
			_sb.content = s;
			_sb.x = 300;
			_sb.y = 100;
			_sb.size = 200;
			this.addChild(_sb);
			
			_hSB = new ScrollBar();
			_hSB.styleName = "hScrollBar1";
			_hSB.direction = ScrollBar.HORIZONTAL;
			_hSB.disArea = {x:100, y:100, width:200, height:200};
			_hSB.content = s;
			_hSB.x = 100;
			_hSB.y = 300;
			_hSB.size = 200;
			this.addChild(_hSB);
			
			this.addChild(sndBtn);
		}
		private var _sb:ScrollBar;
		private var _hSB:ScrollBar;
		
		
		
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			_sb.update();
			_hSB.update();
		}
		//
	}
}