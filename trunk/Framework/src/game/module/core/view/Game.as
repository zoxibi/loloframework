package game.module.core.view
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import game.common.GameConstants;
	import game.common.ModuleName;
	import game.module.core.controls.CoreController;
	import game.module.core.events.ConsoleEvent;
	
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
	import reign.mvc.control.MvcEventDispatcher;
	import reign.ui.Console;
	import reign.ui.Stats;
	import reign.utils.AutoUtil;
	import reign.utils.RandomUtil;
	import reign.utils.TimeUtil;
	import reign.utils.Validator;
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
			Stats.getInstance().container = Common.stage;
			
			Common.sound = SoundManager.getInstance();
			
			Common.mouse = MouseManager.getInstance();
			Common.mouse.skin = AutoUtil.getInstance("skin.Mouse");
			Common.mouse.defaultStyle = GameConstants.MOUSE_STYLE_NORMAL;
			
			Common.ui = GameUIManager.getInstance();
			this.parent.addChild(GameUIManager.getInstance());
			this.parent.removeChild(this);
			Common.ui.init();
			
			
			Common.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			Console.getInstance().addEventListener(DataEvent.DATA, console_dataHandler);
		}
		
		
		/**
		 * 舞台上有按键
		 * @param event
		 */
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			//按下键盘Ctrl+Alt+Shift+A时，如果控制台还未显示，立即显示控制台
			if(event.ctrlKey && event.altKey && event.shiftKey && (event.keyCode == 65) && (Console.getInstance().parent == null))
			{
				Console.getInstance().show();
			}
		}
		
		/**
		 * 控制台有数据推送过来
		 * @param event
		 */
		private function console_dataHandler(event:DataEvent):void
		{
			MvcEventDispatcher.dispatch(ModuleName.CORE, new ConsoleEvent(event.data));
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
			RandomUtil;
			Validator;
		}
		//
	}
}