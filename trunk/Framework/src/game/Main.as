package game
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.ui.Loading;
	
	import reign.common.Common;
	import reign.common.ConfigManager;
	import reign.common.LanguageManager;
	import reign.common.ResLoader;
	import reign.common.StyleManager;
	import reign.events.LoadResourceEvent;
	
	
	[SWF(width="1000", height="600", backgroundColor="#000000", frameRate="25")]
	/**
	 * 测试框架
	 * @author LOLO
	 */
	public class Main extends Sprite
	{
		/**游戏开始时的加载条*/
		private var _loading:Loading;
		/**进场动画*/
		private var _enterMovie:MovieClip;
		/**已经初始化成功的步骤数*/
		private var _initNum:int = 0;
		
		
		public function Main()
		{
			stage.stageFocusRect = false;
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			Common.stage = this.stage;
			Common.initData = LoaderInfo(root.loaderInfo).parameters;
			
			Common.loader = ResLoader.getInstance();
			Common.style = StyleManager.getInstance();
			Common.config = ConfigManager.getInstance();
			Common.language = LanguageManager.getInstance();
			
			loadConfigXml();
			
		}
		
		
		
		/**
		 * 加载网页目录下的Config.xml文件
		 */
		private function loadConfigXml():void
		{
			Common.loader.add("config", "Config.xml", "xml", Math.random() * 999999);
			Common.loader.addEventListener(LoadResourceEvent.ALL_COMPLETE, loadConfigXmlComplete);
			Common.loader.load();
		}
		
		private function loadConfigXmlComplete(event:LoadResourceEvent):void
		{
			Common.loader.removeEventListener(LoadResourceEvent.ALL_COMPLETE, loadConfigXmlComplete);
			
			Common.config.initConfig();
			var resurl:String = Common.getInitDataByKey("resurl");
			if(resurl != null) Common.resServerUrl = resurl;
			loadResConfig();
		}
		
		
		
		/**
		 * 加载资源配置文件
		 */
		private function loadResConfig():void
		{
			var url:String = "assets/{resVersion}/xml/core/ResConfig.xml";
			Common.loader.add("resConfig", url, "xml");
			Common.loader.addEventListener(LoadResourceEvent.ALL_COMPLETE, loadResConfigComplete);
			Common.loader.load();
		}
		
		private function loadResConfigComplete(event:LoadResourceEvent):void
		{
			Common.loader.removeEventListener(LoadResourceEvent.ALL_COMPLETE, loadResConfigComplete);
			Common.config.initResConfig();
			loadLanguage();
		}
		
		
		
		/**
		 * 加载语言包、样式配置、界面配置
		 */
		private function loadLanguage():void
		{
			var info:Object;
			
			//语言包
			info = Common.config.getResConfig("language");
			var type:String = Common.config.getConfig("languageType");
			var url:String = (type == "xml") ? (info.url + ".xml") : info.url;
			Common.loader.add("language", url, "xml", info.version);
			
			//组件样式配置文件
			info = Common.config.getResConfig("style");
			Common.loader.add("style", info.url, "xml", info.version);
			
			//用户界面配置文件
			info = Common.config.getResConfig("uiConfig");
			Common.loader.add("uiConfig", info.url, "xml", info.version);
			
			Common.loader.addEventListener(LoadResourceEvent.ALL_COMPLETE, loadLanguageComplete);
			Common.loader.load();
		}
		
		private function loadLanguageComplete(event:LoadResourceEvent):void
		{
			Common.loader.removeEventListener(LoadResourceEvent.ALL_COMPLETE, loadLanguageComplete);
			
			Common.language.addEventListener("initLanguageComplete", checkInit);
			Common.language.initLanguage();
			Common.config.initUIConfig();
			Common.style.initStyle();
			
			loadLoadingMovie();
		}
		
		
		
		/**
		 * 加载loading动画
		 */
		private function loadLoadingMovie():void
		{
			var url:String = "assets/{resVersion}/swf/core/Loading.swf";
			Common.loader.add("loadingMovie", url, "swf", 1);
			Common.loader.addEventListener(LoadResourceEvent.ALL_COMPLETE, loadLoadingMovieComplete);
			Common.loader.load();
		}
		
		private function loadLoadingMovieComplete(event:LoadResourceEvent):void
		{
			Common.loader.removeEventListener(LoadResourceEvent.ALL_COMPLETE, loadLoadingMovieComplete);
			
			_loading = new Loading(Common.loader.getSWF("loadingMovie") as MovieClip);
			this.addChildAt(_loading, 0);
			
			loadGame();
		}
		
		
		/**
		 * 加载游戏，以及运行时必须的文件
		 */
		private function loadGame():void
		{
			var info:Object;
			
			//组件皮肤
			info = Common.config.getResConfig("component");
			Common.loader.add(Common.language.getLanguage("020101"), info.url, "class", info.version);
			//游戏核心
			info = Common.config.getResConfig("game");
			Common.loader.add(Common.language.getLanguage("020102"), info.url, "swf", info.version);
			
			//核心UI配置
			info = Common.config.getResConfig("mainUIConfig");
			Common.loader.add(Common.language.getLanguage("020103"), info.url, "xml", info.version);
			//核心UI界面
			info = Common.config.getResConfig("mainUIView");
			Common.loader.add(Common.language.getLanguage("020104"), info.url, "class", info.version);
			
			//开发商信息（进场动画）
			info = Common.config.getResConfig("enterMovie");
			Common.loader.add(Common.language.getLanguage("020105"), info.url, "swf", info.version);
			
			_loading.start();
			_loading.addEventListener("loadingMoviePlayFinished", checkInit);
			Common.loader.load();
		}
		
		
		/**
		 * 检查初始化步骤是否已经全部完成，是否已经可以进入游戏了
		 * @param event
		 */
		private function checkInit(event:Event=null):void
		{
			_initNum++;
			
			//共两步：提取语言包完成，加载游戏完成
			if(_initNum == 2) {
				enterGame();
			}
		}
		
		
		/**
		 * 进入游戏
		 */
		private function enterGame():void
		{
			Common.language.removeEventListener("initLanguageComplete", checkInit);
			
			_loading.removeEventListener("loadingMoviePlayFinished", checkInit);
			this.removeChild(_loading);
			_loading.dispose();
			_loading = null;
			
			_enterMovie = Common.loader.getSWF(Common.language.getLanguage("020105")) as MovieClip;
			_enterMovie.gotoAndPlay(1);
			_enterMovie.addEventListener("skip", skipEnterMovie);
			this.addChild(_enterMovie);
		}
		
		
		
		
		/**
		 * 进场动画播放完成，进入游戏
		 * @param event
		 */
		private function skipEnterMovie(event:Event):void
		{
			_enterMovie.removeEventListener("skip", skipEnterMovie);
			this.removeChild(_enterMovie);
			_enterMovie = null;
			
			this.addChild(Common.loader.getSWF(Common.language.getLanguage("020102")));
		}
		//
	}
}