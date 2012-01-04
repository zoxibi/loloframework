package game.module.core.view
{
	import flash.utils.getDefinitionByName;
	
	import game.common.GameConstants;
	import game.common.ModuleName;
	import game.module.loginScene.view.ILoginScene;
	import game.module.testScene.view.ITestScene;
	import game.ui.LoadBar;
	import game.ui.RequestModal;
	
	import reign.common.Common;
	import reign.common.Constants;
	import reign.common.UIManager;

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
			
//			showLoginScene([]);
			showTestScene([]);
		}
		
		
		
		
		/**
		 * 显示【登录场景】
		 * @param args
		 */
		private function showLoginScene(args:Array):void
		{
			if(_loginScene == null)
			{
				showLoadBar();
				var info:Object;
				info = Common.config.getResConfig("loginSceneConfig");
				Common.loader.add(Common.language.getLanguage("020204"), info.url, Constants.RES_TYPE_XML, info.version);
				info = Common.config.getResConfig("loginSceneView");
				Common.loader.add(Common.language.getLanguage("020205"), info.url, Constants.RES_TYPE_CLA, info.version);
				info = Common.config.getResConfig("loginSceneModule");
				Common.loader.add(Common.language.getLanguage("020206"), info.url, Constants.RES_TYPE_CLA, info.version);
				
				Common.loader.load(loadLoginSceneComplete);
			}
			else {
				loadLoginSceneComplete();
			}
		}
		private function loadLoginSceneComplete():void
		{
			hideLoadBar();
			if(_loginScene == null)
			{
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
				showLoadBar();
				var info:Object;
				info = Common.config.getResConfig("testSceneConfig");
				Common.loader.add(Common.language.getLanguage("020201"), info.url, Constants.RES_TYPE_XML, info.version);
				info = Common.config.getResConfig("testSceneView");
				Common.loader.add(Common.language.getLanguage("020202"), info.url, Constants.RES_TYPE_CLA, info.version);
				info = Common.config.getResConfig("testSceneModule");
				Common.loader.add(Common.language.getLanguage("020203"), info.url, Constants.RES_TYPE_CLA, info.version);
				
				Common.loader.load(loadTestSceneComplete);
			}
			else {
				loadTestSceneComplete();
			}
		}
		private function loadTestSceneComplete():void
		{
			hideLoadBar();
			if(_testScene == null)
			{
				_testScene = getDefinitionByName(ModuleName.SCENE_TEST).instance;
				_testScene.sceneID = GameConstants.SCENE_ID_TEST;
			}
			
			switchScene(_testScene);
		}
		//
	}
}


class Enforcer {}