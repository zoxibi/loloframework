package lolo.common
{
	import flash.utils.Dictionary;
	
	import lolo.utils.StringUtil;

	/**
	 * 配置信息管理
	 * @author LOLO
	 */
	public class ConfigManager implements IConfigManager
	{
		/**单例的实例*/
		private static var _instance:ConfigManager;
		
		/**网页目录下的Config.xml配置文件*/
		private var _config:Dictionary;
		/**资源配置文件*/
		private var _resConfig:Dictionary;
		/**界面配置文件*/
		private var _uiConfig:Dictionary;
		/**音频配置文件*/
		private var _soundConfig:Dictionary;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():ConfigManager
		{
			if(_instance == null) _instance = new ConfigManager(new Enforcer());
			return _instance;
		}
		
		
		public function ConfigManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.config获取实例");
				return;
			}
		}
		
		
		/**
		 * 初始化网页目录下的Config.xml
		 */
		public function initConfig():void
		{
			var config:XML = Common.loader.getResByUrl("Config.xml", true);
			_config = new Dictionary();
			for each(var item:XML in config.children())
			{
				_config[String(item.name())] = String(item.@value);
			}
			
			Common.resVersion = getConfig("resVersion");
			Common.serviceUrl = getConfig("socketServiceUrl");
		}
		
		/**
		 * 初始化资源配置文件
		 */
		public function initResConfig():void
		{
			var config:XML = Common.loader.getResByUrl("assets/{resVersion}/xml/core/ResConfig.xml", true);
			Common.version = config.version;
			
			_resConfig = new Dictionary();
			for each(var item:XML in config.children())
			{
				_resConfig[String(item.name())] = {
					url		: String(item.@url),
					version	: int(item.@version),
					type	: String(item.@type),
					nameID	: String(item.@nameID)
				}
			}
		}
		
		/**
		 * 初始化界面配置文件
		 */
		public function initUIConfig():void
		{
			var config:XML = Common.loader.getResByConfigName("uiConfig", true);
			_uiConfig = new Dictionary();
			for each(var item:XML in config.children())
			{
				_uiConfig[String(item.name())] = String(item.@value);
			}
		}
		
		
		/**
		 * 初始化音频配置文件
		 */
		public function initSoundConfig():void
		{
			var config:XML = Common.loader.getResByConfigName("soundConfig", true);
			_soundConfig = new Dictionary();
			for each(var item:XML in config.children())
			{
				_uiConfig[String(item.name())] = String(item.@value);
			}
		}
		
		
		
		/**
		 * 获取网页目录下Config.xml文件的配置信息
		 * @param name 配置的名称
		 */
		public function getConfig(name:String):String
		{
			if(_config == null) return "";
			return _config[name];
		}
		
		/**
		 * 获取资源配置文件信息
		 * @param name 配置的名称
		 * @return { url, version, type, nameID }
		 */
		public function getResConfig(name:String):Object
		{
			return _resConfig[name];
		}
		
		/**
		 * 获取界面配置文件信息
		 * @param name 配置的名称
		 * @param rest 可变参数
		 * @return
		 */
		public function getUIConfig(name:String, ...rest):String
		{
			return StringUtil.substitute(_uiConfig[name], rest);
		}
		
		
		/**
		 * 获取音频配置文件信息
		 * @param name 配置的名称
		 * @return
		 */
		public function getSoundConfig(name:String):String
		{
			return _soundConfig[name];
		}
		//
	}
}


class Enforcer {}