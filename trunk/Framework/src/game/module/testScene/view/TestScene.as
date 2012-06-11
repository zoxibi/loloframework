package game.module.testScene.view
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.components.NumberText;
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
		
		public var nt:NumberText;
		
		
		private var _data:TestSceneData;
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			
			sndBtn.addEventListener(MouseEvent.CLICK, sndBtn_clickHandler);
			
			
			nt = new NumberText();
			nt.size = 20;
			nt.originalColor = 0;
			this.addChild(nt);
		}
		
		private var _n:int = 100;
		private function sndBtn_clickHandler(event:MouseEvent):void
		{
			//soundPop.showOrHide();
			_n--;
			nt.text = _n.toString();
		}
		//
	}
}