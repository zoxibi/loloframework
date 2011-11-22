package game.module.core.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.common.GameConstants;
	import game.module.core.controls.CoreController;
	import game.net.HttpService;
	
	import reign.common.Common;
	import reign.common.ConfigManager;
	import reign.common.LanguageManager;
	import reign.common.MouseManager;
	import reign.common.ResLoader;
	import reign.common.SoundManager;
	import reign.components.Alert;
	import reign.core.Scene;
	import reign.core.Window;
	import reign.data.HashMap;
	import reign.data.LastTime;
	import reign.ui.Console;
	import reign.utils.AutoUtil;
	import reign.utils.TimeUtil;
	import reign.utils.bind.BindUtil;

	/**
	 * 游戏核心
	 * 该类会引入其他模块中常用的类，同时，该类也是其他模块优化的针对程序
	 * @author LOLO
	 */
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			new CoreController();
			
			importClass();
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		
		/**
		 * 添加到舞台上时
		 * @param event
		 */
		private function addedToStageHandler(event:Event):void
		{
			if(!this.parent) return;
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			TimeUtil.day	= Common.language.getLanguage("030101");
			TimeUtil.days	= Common.language.getLanguage("030102");
			TimeUtil.hour	= Common.language.getLanguage("030103");
			TimeUtil.minute	= Common.language.getLanguage("030104");
			TimeUtil.second	= Common.language.getLanguage("030105");
			
			TimeUtil.dFormat = Common.language.getLanguage("030201");
			TimeUtil.hFormat = Common.language.getLanguage("030202");
			TimeUtil.mFormat = Common.language.getLanguage("030203");
			TimeUtil.sFormat = Common.language.getLanguage("030204");
			
			Alert.OK	= Common.language.getLanguage("030301");
			Alert.CANCEL= Common.language.getLanguage("030302");
			Alert.YES	= Common.language.getLanguage("030303");
			Alert.NO	= Common.language.getLanguage("030304");
			Alert.CLOSE	= Common.language.getLanguage("030305");
			Alert.BACK	= Common.language.getLanguage("030306");
			
			Console.getInstance().container = Common.stage;
			
			Common.service = HttpService.getInstance();
			Common.sound = SoundManager.getInstance();
			
			Common.mouse = MouseManager.getInstance();
			Common.mouse.skin = AutoUtil.getInstance("skin.Mouse");
			Common.mouse.defaultStyle = GameConstants.MOUSE_STYLE_NORMAL;
			
			Common.ui = GameUIManager.getInstance();
			this.parent.addChild(GameUIManager.getInstance());
			this.parent.removeChild(this);
			Common.ui.init();
		}
		
		
		
		/**
		 * 导入模块中常用到的类
		 */
		private function importClass():void
		{
			HashMap;
			LastTime;
			
			Scene;
			Window;
			
			ResLoader;
			ConfigManager;
			LanguageManager;
			
			BindUtil;
			TimeUtil;
		}
		//
	}
}