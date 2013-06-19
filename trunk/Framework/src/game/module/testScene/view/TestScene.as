package game.module.testScene.view
{
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.core.Scene;
	import lolo.rpg.map.RpgMap;

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
		private var _map:RpgMap = new RpgMap();
		
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getResByConfigName("testSceneConfig"));
			
		}
		
		
		override protected function startup():void
		{
			_map.init("101");
			this.hide();
		}
		//
	}
}