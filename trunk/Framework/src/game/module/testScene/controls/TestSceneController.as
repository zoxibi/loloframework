package game.module.testScene.controls
{
	import game.common.ModuleName;
	
	import reign.mvc.control.FrontController;
	import reign.mvc.control.MvcEventDispatcher;
	
	/**
	 * 【测试场景】命令管理
	 * @author LOLO
	 */
	public class TestSceneController extends FrontController
	{
		public function TestSceneController()
		{
			super();
			_eventDispatcher = MvcEventDispatcher.getInstance(ModuleName.SCENE_TEST);
		}
		//
	}
}