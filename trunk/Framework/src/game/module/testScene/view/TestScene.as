package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.components.ImageLoader;
	import lolo.core.Scene;
	import lolo.effects.PropertyMovie;

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
			img.fileName = "2";
			this.addChild(img);
			
			this.addChild(sndBtn);
			
			_pm = new PropertyMovie(img, PropertyMovie.FRAMES_SHAKE);
		}
		
		
		
		
		private var _pm:PropertyMovie;
		
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			if(!_pm.running) _pm.play(0);
			
			_pm.fps = (_pm.fps == 25) ? 5 : 25;
		}
		//
	}
}