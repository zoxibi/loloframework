package lolo.data
{
	import lolo.common.Common;
	import lolo.utils.StringUtil;

	/**
	 * 加载项数据模型
	 * @author LOLO
	 */
	public class LoadItemModel
	{
		/**默认组*/
		public static const GROUP_DEFAULT:String = "public";
		/**暗中加载组*/
		public static const GROUP_SECRETLY:String = "secretly";
		
		/**优先级为0时，默认递增的优先级*/
		private static var _priority:int = 0;
		
		/**在配置文件(ResConfig)中的名称*/
		public var configName:String;
		/**url的替换参数*/
		public var urlArgs:Array;
		
		/**文件的url（未格式化的url）*/
		public var url:String;
		/**文件的版本号*/
		public var version:int;
		/**文件的类型*/
		public var type:String;
		/**文件的名称（不是必填，可重复）*/
		public var name:String;
		/**在加载该文件之前，需要加载好的文件url列表（未格式化的url）*/
		public var urlList:Array;
		
		/**所属组的key*/
		public var group:String;
		/**是否为暗中加载项*/
		public var isSecretly:Boolean;
		/**加载优先级，数字越大，优先级越高。所属组的优先级=组中所有文件的最高优先级（正常加载项的优先级高于一切暗中加载项）*/
		public var priority:int;
		
		/**是否需要格式化文件的url*/
		public var needToFormatUrl:Boolean;
		/**文件是否已经加载完毕*/
		public var hasLoaded:Boolean;
		
		/**总字节数*/
		public var bytesTotal:Number = 1;
		/**已加载的字节数*/
		public var bytesLoaded:Number = 0;
		
		/**所使用的加载器[Loader 或  URLLoader]*/
		public var loader:*;
		/**已经加载好的数据*/
		public var data:*;
		
		
		public function LoadItemModel(	configName:String=null,group:String="public",
										isSecretly:Boolean=false, priority:int=0,
										urlArgs:Array=null, urlList:Array=null,
										url:String=null, type:String="class", version:int=0, name:String=null,
										needToFormatUrl:Boolean=true
		) {
			this.url = url;
			this.group = group;
			this.type = type;
			this.name = name;
			this.version = version;
			this.isSecretly = isSecretly;
			this.priority = (priority == 0) ? --_priority : priority;
			this.urlList = (urlList == null) ? [] : urlList;
			this.needToFormatUrl = needToFormatUrl;
			
			setConfigName(configName, urlArgs);
		}
		
		
		/**
		 * 在配置文件(ResConfig)中的名称。可配参数{ url, version, type, name }，至少应包含url
		 * @param value
		 */
		public function setConfigName(configName:String, urlArgs:Array=null):void
		{
			this.configName = configName;
			this.urlArgs = urlArgs;
			
			if(configName != null) {
				var config:Object = Common.config.getResConfig(configName);
				this.version = config.version;
				this.type = config.type;
				this.url = (urlArgs != null) ? StringUtil.substitute(config.url, urlArgs) : config.url;
				if(config.nameID != "") this.name = Common.language.getLanguage(config.nameID);
			}
		}
		
		
		
		/**
		 * 添加urlList(通过在Config中的名称列表)。如果url还没加载完成或没在加载队列中，将会自动添加到加载队列。
		 * @param rest
		 * @return 
		 */
		public function addUrlListByCN(...rest):LoadItemModel
		{
			for(var i:int=0; i < rest.length; i++)
			{
				Common.loader.add(new LoadItemModel(rest[i], group, isSecretly));
				urlList.push(Common.config.getResConfig(rest[i]).url);
			}
			return this;
		}
		//
	}
}