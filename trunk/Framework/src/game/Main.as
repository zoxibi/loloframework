package game
{
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.ui.Loading;
	
	import lolo.common.Common;
	import lolo.common.ConfigManager;
	import lolo.common.LanguageManager;
	import lolo.common.LoadManager;
	import lolo.common.StyleManager;
	import lolo.data.LoadItemModel;
	import lolo.events.LoadEvent;
	
	
	[SWF(width="1000", height="600", backgroundColor="#FFFFFF", frameRate="25")]
	/**
	 * LOLO的Web框架
	 * @author LOLO
	 */
	public class Main extends Sprite
	{
		/**当前加载到第几步了*/
		private var _loadStep:int = 0;
		/**游戏开始时的加载条*/
		private var _loading:Loading;
		/**进场动画*/
		private var _enterMovie:MovieClip;
		
		
		public function Main()
		{
			stage.stageFocusRect = false;
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			Common.stage = this.stage;
			Common.initData = LoaderInfo(root.loaderInfo).parameters;
			
			Common.style = StyleManager.getInstance();
			Common.config = ConfigManager.getInstance();
			Common.language = LanguageManager.getInstance();
			Common.loader = LoadManager.getInstance();
			
			Common.loader.addEventListener(LoadEvent.GROUP_COMPLETE, loadGroupCompleteHander);
			loadGroupCompleteHander();
		}
		
		
		/**
		 * 加载完成
		 * @param event
		 */
		private function loadGroupCompleteHander(event:Event=null):void
		{
			_loadStep++;
			switch(_loadStep)
			{
				case 1:
					//加载网页目录下的Config.xml文件
					Common.loader.add(new LoadItemModel(null, "public", false, 0, null, null,
						"Config.xml", "xml"));
					break;
				
				case 2:
					Common.config.initConfig();
					var resurl:String = Common.getInitDataByKey("resurl");
					if(resurl != null) Common.resServerUrl = resurl;
					
					//加载资源配置文件
					Common.loader.add(new LoadItemModel(null, "public", false, 0, null, null,
						"assets/{resVersion}/xml/core/ResConfig.xml", "xml"));
					break;
					
				case 3:
					Common.config.initResConfig();
					
					//语言包
					var lim:LoadItemModel = new LoadItemModel("language");
					lim.type = Common.config.getConfig("languageType");
					if(lim.type == "xml") lim.url += ".xml";
					Common.loader.add(lim);
					//组件样式配置文件
					Common.loader.add(new LoadItemModel("style"));
					//用户界面配置文件
					Common.loader.add(new LoadItemModel("uiConfig"));
					//音频配置文件
					Common.loader.add(new LoadItemModel("soundConfig"));
					//loading动画
					Common.loader.add(new LoadItemModel("loadingMovie"));
					break;
				
				case 4:
					Common.language.initLanguage();
					Common.config.initUIConfig();
					Common.config.initSoundConfig();
					Common.style.initStyle();
					_loading = new Loading(Common.loader.getResByConfigName("loadingMovie", true));
					this.addChildAt(_loading, 0);
					
					Common.loader.removeEventListener(LoadEvent.GROUP_COMPLETE, loadGroupCompleteHander);
					Common.loader.add(new LoadItemModel("component"));
					Common.loader.add(new LoadItemModel("game"));
					Common.loader.add(new LoadItemModel("mainUIConfig"));
					Common.loader.add(new LoadItemModel("mainUIView"));
					Common.loader.add(new LoadItemModel("enterMovie"));
					
					_loading.start();
					_loading.addEventListener("loadingMoviePlayFinished", loadGroupCompleteHander);
					break;
				
				case 5:
					_loading.removeEventListener("loadingMoviePlayFinished", loadGroupCompleteHander);
					this.removeChild(_loading);
					_loading.dispose();
					_loading = null;
					
					_enterMovie = Common.loader.getResByConfigName("enterMovie", true);
					_enterMovie.gotoAndPlay(1);
					_enterMovie.addEventListener("skip", loadGroupCompleteHander);
					this.addChild(_enterMovie);
					break;
				
				case 6:
					_enterMovie.removeEventListener("skip", loadGroupCompleteHander);
					this.removeChild(_enterMovie);
					_enterMovie = null;
					this.addChild(Common.loader.getResByConfigName("game", true));
					return;
			}
			Common.loader.start();
		}
		//
	}
}