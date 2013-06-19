package game.module.core.view
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import game.common.GameConstants;
	import game.common.ModuleName;
	import game.module.core.controls.CoreController;
	import game.module.core.events.ConsoleEvent;
	
	import lolo.common.AnimationManager;
	import lolo.common.Common;
	import lolo.common.ConfigManager;
	import lolo.common.LanguageManager;
	import lolo.common.LoadManager;
	import lolo.common.MouseManager;
	import lolo.common.SoundManager;
	import lolo.components.Alert;
	import lolo.core.Scene;
	import lolo.core.Window;
	import lolo.data.HashMap;
	import lolo.data.LastTime;
	import lolo.mvc.control.MvcEventDispatcher;
	import lolo.ui.Console;
	import lolo.ui.Stats;
	import lolo.utils.AutoUtil;
	import lolo.utils.RandomUtil;
	import lolo.utils.TimeUtil;
	import lolo.utils.Validator;
	import lolo.utils.bind.BindUtil;
	
	import starling.core.Starling;
	
	
	
	/**
	 * 游戏核心
	 * 该类会引入其他模块中常用的类，同时，该类也是其他模块优化的针对程序
	 * @author LOLO
	 */
	public class Game extends flash.display.Sprite
	{
		private var _starling:Starling;
		
		
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
			Common.animation = AnimationManager.getInstance();
			
			Common.mouse = MouseManager.getInstance();
			Common.mouse.skin = AutoUtil.getInstance("skin.Mouse");
			Common.mouse.defaultStyle = GameConstants.MOUSE_STYLE_NORMAL;
			
			Common.ui = GameUIManager.getInstance();
			this.parent.addChild(GameUIManager.getInstance());
			this.parent.removeChild(this);
			Common.ui.init();
			
			
			_starling = new Starling(StarlingRoot, Common.stage);
			_starling.start();
			
			
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
			
			LoadManager;
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



import starling.display.Sprite;
class StarlingRoot extends starling.display.Sprite { }