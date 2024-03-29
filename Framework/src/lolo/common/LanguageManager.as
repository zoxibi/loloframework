package lolo.common
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import lolo.utils.StringUtil;
	import lolo.utils.zip.ZipReader;

	/**
	 * 语言包管理
	 * @author LOLO
	 */
	public class LanguageManager extends EventDispatcher implements ILanguageManager
	{
		/**单例的实例*/
		private static var _instance:LanguageManager;
		
		/**提取完成的语言包储存在此*/
		private var _language:Dictionary;
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():LanguageManager
		{
			if(_instance == null) _instance = new LanguageManager(new Enforcer());
			return _instance;
		}
		
		
		public function LanguageManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.language获取实例");
				return;
			}
			
			_language = new Dictionary();
		}
		
		
		/**
		 * 初始化语言包
		 */
		public function initLanguage():void
		{
			var languageXML:XML;
			//获取zip类型的语言包
			if(Common.config.getConfig("languageType") == "zip")
			{
				var zip:ZipReader = Common.loader.getResByConfigName("language", true);
				languageXML = new XML(zip.getFile("Language.xml"));
			}
			else {
				languageXML = Common.loader.getResByUrl(Common.config.getResConfig("language").url + ".xml", true);
			}
			
			for each(var item:XML in languageXML.item)
			{
				_language[String(item.@id)] = item.toString().replace(/\[br\]/g, "\n");
			}
		}
		
		
		/**
		 * 通过ID在语言包中获取对应的字符串
		 * @param id 在语言包中的ID
		 * @param rest 用该参数替换字符串内的"{n}"标记
		 * @return 
		 */
		public function getLanguage(id:String, ...rest):String
		{
			var str:String = _language[id];
			if(rest.length > 0) {
				str = StringUtil.substitute(str, rest);
			}
			return str;
		}
		//
	}
}


class Enforcer {}