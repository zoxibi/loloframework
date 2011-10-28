package game.module.core.view
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	import game.common.GameConstants;
	import game.common.ModuleName;
	import game.module.chat.view.IChat;
	import game.module.testScene.view.ITestScene;
	import game.ui.LoadBar;
	
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
		
		/**聊天模块*/
		private var _chat:IChat;
		
		
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
			showTestScene([]);
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
				
				
				info = Common.config.getResConfig("chatConfig");
				Common.loader.add(Common.language.getLanguage("020301"), info.url, Constants.RES_TYPE_XML, info.version);
				info = Common.config.getResConfig("chatView");
				Common.loader.add(Common.language.getLanguage("020302"), info.url, Constants.RES_TYPE_CLA, info.version);
				info = Common.config.getResConfig("chatModule");
				Common.loader.add(Common.language.getLanguage("020303"), info.url, Constants.RES_TYPE_CLA, info.version);
				
				
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
			
			if(_chat == null)
			{
				_chat = getDefinitionByName(ModuleName.MODULE_CHAT).instance;
				addChildToLayer(_chat as DisplayObject, Constants.LAYER_NAME_UI);
			}
		}
		//
	}
}


class Enforcer {}