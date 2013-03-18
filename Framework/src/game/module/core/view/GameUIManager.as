package game.module.core.view
{
	import flash.utils.getDefinitionByName;
	
	import game.common.GameConstants;
	import game.common.ModuleName;
	import game.module.loginScene.view.ILoginScene;
	import game.module.testScene.view.ITestScene;
	import game.ui.LoadBar;
	import game.ui.RequestModal;
	
	import lolo.common.Common;
	import lolo.common.UIManager;
	import lolo.data.LoadItemModel;

	/**
	 * 游戏用户界面管理
	 * @author LOLO
	 */
	public class GameUIManager extends UIManager implements IGameUIManager
	{
		/**单例的实例*/
		private static var _instance:GameUIManager;
		
		
		/**测试场景*/
		private var _testScene:ITestScene;
		/**登录场景*/
		private var _loginScene:ILoginScene;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():GameUIManager
		{
			if(_instance == null) _instance = new GameUIManager(new Enforcer());
			return _instance;
		}
		
		
		public function GameUIManager(enforcer:Enforcer)
		{
			if(!enforcer) {
				throw new Error("请通过Common.ui获取实例");
				return;
			}
		}
		
		
		override public function init():void
		{
			super.init();
			
			_loadBar = new LoadBar();
			_requestModal = new RequestModal();
			
			showScene(GameConstants.SCENE_ID_TEST);
		}
		
		
		override public function showScene(sceneID:int, ...rest):void
		{
			super.showScene(sceneID, rest);
			
			switch(sceneID)
			{
				//测试场景
				case GameConstants.SCENE_ID_TEST:
					showTestScene(rest);
					break;
				
				//登录场景
				case GameConstants.SCENE_ID_LOGIN:
					showLoginScene(rest);
					break;
			}
		}
		
		
		
		
		/**
		 * 显示【登录场景】
		 * @param args
		 */
		private function showLoginScene(args:Array):void
		{
			if(_loginScene == null)
			{
				showLoadBar(ModuleName.SCENE_LOGIN);
				Common.loader.add(new LoadItemModel("loginSceneModule", ModuleName.SCENE_LOGIN).addUrlListByCN(
					"loginSceneConfig", "loginSceneView"));
				Common.loader.start(ModuleName.SCENE_LOGIN, loadLoginSceneComplete);
			}
			else {
				loadLoginSceneComplete();
			}
		}
		private function loadLoginSceneComplete():void
		{
			hideLoadBar();
			
			if(_loginScene == null) {
				_loginScene = getDefinitionByName(ModuleName.SCENE_LOGIN).instance;
				_loginScene.sceneID = GameConstants.SCENE_ID_LOGIN;
			}
			switchScene(_loginScene);
		}
		
		
		
		
		
		
		/**
		 * 显示【测试场景】
		 * @param args
		 */
		private function showTestScene(args:Array):void
		{
			if(_testScene == null)
			{
				showLoadBar(ModuleName.SCENE_TEST);
				Common.loader.add(new LoadItemModel("testSceneModule", ModuleName.SCENE_TEST).addUrlListByCN(
					"testSceneConfig", "testSceneView"));
				Common.loader.start(ModuleName.SCENE_TEST, loadTestSceneComplete);
			}
			else {
				loadTestSceneComplete();
			}
		}
		private function loadTestSceneComplete():void
		{
			hideLoadBar();
			
			if(_testScene == null) {
				_testScene = getDefinitionByName(ModuleName.SCENE_TEST).instance;
				_testScene.sceneID = GameConstants.SCENE_ID_TEST;
			}
			switchScene(_testScene);
		}
		//
	}
}


class Enforcer {}