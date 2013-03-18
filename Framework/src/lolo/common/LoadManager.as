package lolo.common
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import lolo.data.HashMap;
	import lolo.data.IHashMap;
	import lolo.data.LoadItemModel;
	import lolo.events.LoadEvent;
	import lolo.utils.StringUtil;
	import lolo.utils.zip.ZipReader;
	
	/**
	 * 加载管理器
	 * @author LOLO
	 */
	public class LoadManager extends EventDispatcher implements ILoadManager
	{
		/**允许并发加载的最大数量*/
		private static const LOADING_MAX_COUNT:uint = 4;
		/**暗中加载时，允许并发加载的最大数量*/
		private static const SECRETLY_LOADING_MAX_COUNT:uint = 2;
		/**单例的实例*/
		private static var _instance:LoadManager;
		
		/**需要加载的加载项队列*/
		private var _loadList:HashMap;
		/**正在加载的加载项列表*/
		private var _loadingList:HashMap;
		/**已经加载好的加载项队列*/
		private var _resList:HashMap;
		/**临时保存loader的引用列表（防止loader被GC）*/
		private var _tempLoaderList:Dictionary;
		/**是否被主动停止了*/
		private var _isStop:Boolean = true;
		/**回调列表（key:group）*/
		private var _callbackList:Dictionary;
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():LoadManager
		{
			if(_instance == null) _instance = new LoadManager(new Enforcer());
			return _instance;
		}
		
		
		
		public function LoadManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.loader获取实例");
				return;
			}
			
			_loadList = new HashMap();
			_loadingList = new HashMap();
			_resList = new HashMap();
			_tempLoaderList = new Dictionary();
			_callbackList = new Dictionary();
		}
		
		
		public function add(lim:LoadItemModel, isSort:Boolean=false):LoadItemModel
		{
			var oldLim:LoadItemModel = _loadList.getValueByKey(lim.url);//已经在加载队列中了
			if(oldLim == null) {
				oldLim = _loadingList.getValueByKey(lim.url);//正在加载中
			}
			else {
				isSort = true;
			}
			
			if(oldLim == null) {
				oldLim = _resList.getValueByKey(lim.url);//已经加载完毕了
			}
			
			if(oldLim != null) {
				if(oldLim.isSecretly != lim.isSecretly || oldLim.isSecretly != lim.isSecretly) isSort = true;
				oldLim.isSecretly = lim.isSecretly;
				oldLim.priority = lim.priority;
				oldLim.group = lim.group;
				if(isSort) sortLoadList();
				return oldLim;
			}
			
			_loadList.add(lim, lim.url);
			if(isSort) sortLoadList();
			return lim;
		}
		
		/**
		 * 对需要加载的文件列表进行排序
		 */
		private function sortLoadList():void
		{
			var list:Array = _loadList.values.sort(limPrioritySort);
			_loadList = new HashMap();
			for(var i:int=0; i < list.length; i++) _loadList.add(list[i], list[i].url);
		}
		
		/**
		 * 加载项数据模型的加载优先级排序方法
		 * @param lim1
		 * @param lim2
		 * @return 
		 */
		private function limPrioritySort(lim1:LoadItemModel, lim2:LoadItemModel):int
		{
			if(lim1.isSecretly && !lim2.isSecretly) return 1;
			if(lim2.isSecretly && !lim1.isSecretly) return -1;
			if(lim1.priority > lim2.priority) return -1;
			if(lim2.priority > lim1.priority) return 1;
			return 0;
		}
		
		
		public function start(group:String="public", callback:Function=null):void
		{
			if(_callbackList[group] == null) _callbackList[group] = [];
			
			if(getGroupLoaded(group)) {
				if(callback != null) callback();
				dispatchEvent(new LoadEvent(LoadEvent.GROUP_COMPLETE));
			}
			
			if(_loadList.length > 0)  {
				if(callback != null) _callbackList[group].push(callback);
				_isStop = false;
				loadNext();
			}
		}
		
		
		/**
		 * 加载下一个文件
		 */
		private function loadNext():void
		{
			if(_isStop) return;//已经被停止了
			if(_loadList.length == 0) return;//没有需要加载的资源
			if(_loadingList.length >= LOADING_MAX_COUNT) return;//达到了允许的最大并发加载数
			if(isSecretly && _loadingList.length >= SECRETLY_LOADING_MAX_COUNT) return;
			
			var lim:LoadItemModel;
			var prevLim:LoadItemModel;
			var tempLim:LoadItemModel;
			var i:int;
			var n:int;
			//有文件正在加载，尝试取出与正在加载的文件组相同的文件
			if(_loadingList.length > 0) {
				for(n = 0; n < _loadingList.length; n++) {
					prevLim = _loadingList.getValueByIndex(n);
					for(i = 0; i < _loadList.length; i++) {
						tempLim = _loadList.getValueByIndex(i);
						if(tempLim.group == prevLim.group && getCanLoad(tempLim)) {
							lim = tempLim;
							break;
						}
					}
				}
			}
			
			//没有可加载的同组文件，按顺序拿一个可加载的文件
			if(lim == null) {
				for(i = 0; i < _loadList.length; i++) {
					tempLim = _loadList.getValueByIndex(i);
					if(getCanLoad(tempLim)) {
						lim = tempLim;
						break;
					}
				}
			}
			
			//完全没文件可加载
			if(lim == null) {
//				trace("要加载的文件所依赖的文件列表中，有文件还未加载完毕。");
				return;
			}
			
			_loadList.removeByKey(lim.url);
			_loadingList.add(lim, lim.url);
			dispatchEvent(new LoadEvent(LoadEvent.START, lim));
			
			//创建loader，并侦听事件
			var loader:EventDispatcher;
			if(lim.type == Constants.RES_TYPE_ZIP || lim.type == Constants.RES_TYPE_XML) {
				lim.loader = new URLLoader();
				loader = lim.loader;
			}
			else {
				lim.loader = new Loader();
				loader = lim.loader.contentLoaderInfo;
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			
			//解析出文件的url
			var resUrl:String = lim.needToFormatUrl
				? Common.getResUrl(lim.url, lim.version)
				: lim.url;
			
			//根据类型，开始加载
			switch(lim.type)
			{
				case Constants.RES_TYPE_CLA:
					lim.loader.load(new URLRequest(resUrl), new LoaderContext(true, ApplicationDomain.currentDomain));
					break;
				case Constants.RES_TYPE_XML:
					lim.loader.load(new URLRequest(resUrl));
					break;
				case Constants.RES_TYPE_IMG:
					lim.loader.load(new URLRequest(resUrl), new LoaderContext(true));
					break;
				case Constants.RES_TYPE_SWF:
					lim.loader.load(new URLRequest(resUrl), new LoaderContext(true, ApplicationDomain.currentDomain));
					break;
				case Constants.RES_TYPE_ZIP:
					lim.loader.dataFormat = URLLoaderDataFormat.BINARY;
					lim.loader.load(new URLRequest(resUrl));
					break;
				default:
					trace("资源类型\"" + lim.type + "\"无法识别");
			}
			
			if(_loadingList.length < LOADING_MAX_COUNT) loadNext();
		}
		
		/**
		 * 获取该文件是否可以加载了（所依赖的文件是否全部加载完毕了）
		 * @param lim
		 * @return 
		 */
		private function getCanLoad(lim:LoadItemModel):Boolean
		{
			for(var i:int = 0; i < lim.urlList.length; i++) {
				if(_resList.getValueByKey(lim.urlList[i]) == null) return false;
			}
			return true;
		}
		
		
		/**
		 * 加载中
		 * @param event
		 */
		private function progressHandler(event:ProgressEvent):void
		{
			var lim:LoadItemModel = getLimByLoader(event.target);
			lim.bytesLoaded = event.bytesLoaded;
			lim.bytesTotal = event.bytesTotal;
			dispatchEvent(new LoadEvent(LoadEvent.PROGRESS, lim));
		}
		
		/**
		 * 加载失败
		 * @param event
		 */
		private function errorHandler(event:Event):void
		{
			var lim:LoadItemModel = getLimByLoader(event.target);
			removeLoader(lim);
			dispatchEvent(new LoadEvent(LoadEvent.ERROR, lim));
		}
		
		/**
		 * 加载完成
		 * @param event
		 */
		private function completeHandler(event:Event):void
		{
			var lim:LoadItemModel = getLimByLoader(event.target);
			switch(lim.type)
			{
				case Constants.RES_TYPE_XML:
					lim.data = new XML(event.target.data);
					break;
				case Constants.RES_TYPE_IMG:
					lim.data = (lim.loader.content as Bitmap).bitmapData.clone();
					break;
				case Constants.RES_TYPE_SWF:
					lim.data = lim.loader.content;
					break;
				case Constants.RES_TYPE_ZIP:
					lim.data = new ZipReader(event.target.data);
					break;
			}
			if(lim.type == Constants.RES_TYPE_CLA) {
				//调试环境，不是程序模块资源
				if(Common.config.getConfig("bin") == "debug" && lim.url.indexOf("game/module/") == -1 && lim.url.indexOf("Game.swf") == -1) {
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadClassBytesCompleteHandler);
					loader.loadBytes(lim.loader.contentLoaderInfo.bytes, new LoaderContext(false, ApplicationDomain.currentDomain));
					_tempLoaderList[loader] = lim;
				}
				else {
					loadClassBytesCompleteHandler(null, lim);
				}
			}
			else {
				loadItemComplete(lim);
			}
		}
		
		/**
		 * bytes方式加载class资源成功
		 */
		private function loadClassBytesCompleteHandler(event:Event, lim:LoadItemModel=null):void
		{
			if(event != null) {
				event.target.loader.unload();
				event.target.removeEventListener(Event.COMPLETE, loadClassBytesCompleteHandler);
				lim = _tempLoaderList[event.target.loader];
				delete _tempLoaderList[event.target.loader];
			}
			//如果被停止了，或者已经被再次创建了（debug环境才会有这异步问题）
			if(_isStop || _loadList.getValueByKey(lim.url) != null || _resList.getValueByKey(lim.url) != null) return;
			
			lim.data = true;
			loadItemComplete(lim);
		}
		
		
		/**
		 * 加载单个文件完成
		 * @param lim
		 */
		private function loadItemComplete(lim:LoadItemModel):void
		{
			_resList.add(lim, lim.url);
			removeLoader(lim);
			lim.hasLoaded = true;
			lim.bytesLoaded = lim.bytesTotal;
			
			dispatchEvent(new LoadEvent(LoadEvent.ITEM_COMPLETE, lim));
			if(getGroupLoaded(lim.group)) {
				if(_callbackList[lim.group] != null) {
					for(var i:int=0; i < _callbackList[lim.group].length; i++) {
						_callbackList[lim.group][i]();
					}
					_callbackList[lim.group] = null;
				}
				dispatchEvent(new LoadEvent(LoadEvent.GROUP_COMPLETE, lim));
			}
			loadNext();
		}
		
		
		public function getGroupLoaded(group:String):Boolean
		{
			var list:Array = _loadList.values.concat(_loadingList.values);
			for(var i:int = 0; i < list.length; i++) {
				if(list[i].group == group) return false;
			}
			return true;
		}
		
		
		/**
		 * 根据loader来获取加载项数据模型
		 * @param loader
		 * @return 
		 */
		private function getLimByLoader(loader:Object):LoadItemModel
		{
			if(loader is LoaderInfo) loader = loader.loader;
			for(var i:int = 0; i < _loadingList.length; i++) {
				var tempLim:LoadItemModel = _loadingList.getValueByIndex(i);
				if(tempLim.loader == loader) return tempLim;
			}
			return null;
		}
		
		
		/**
		 * 从正在加载队列中移除加载项，并移除加载项的所有加载事件、清除loader
		 * @param lim
		 */
		private function removeLoader(lim:LoadItemModel):void
		{
			if(lim.loader == null) return;//已经被清理过了
			var loader:Object = (lim.type == Constants.RES_TYPE_ZIP || lim.type == Constants.RES_TYPE_XML)
				? lim.loader
				: lim.loader.contentLoaderInfo;
			loader.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
			loader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.removeEventListener(Event.COMPLETE, completeHandler);
			
			try { loader.close(); }
			catch(error:Error) {}
			try { loader.unload(); }
			catch(error:Error) {}
			lim.loader = null;
			
			_loadingList.removeByKey(lim.url);
		}
		
		
		public function stop():void
		{
			_isStop = true;
			var loadingList:IHashMap = _loadingList.clone();
			for(var i:int = 0; i < loadingList.length; i++) {
				var lim:LoadItemModel = loadingList.getValueByIndex(i);
				_loadList.add(lim, lim.url);
				removeLoader(lim);
			}
			sortLoadList();
		}
		
		
		public function clearLoadList(group:String="all"):void
		{
			var i:int;
			var lim:LoadItemModel;
			var list:Array = _loadList.values.concat(_loadingList.values.concat());
			for(i = 0; i < list.length; i++) {
				lim = list[i];
				if(group == "all" || lim.group == group) {
					removeLoader(lim);
					_loadList.removeByKey(lim.url);
				}
			}
		}
		
		
		public function getGroupProgress(group:String="public"):Object
		{
			var numTotal:int = 0;
			var numLoaded:int = 0;
			var progress:Number = 0;
			var lim:LoadItemModel;
			var list:Array = _loadList.values.concat(_loadingList.values);
			list = list.concat(_resList.values);
			for(var i:int = 0; i < list.length; i++)
			{
				lim = list[i];
				if(lim.group == group) {
					numTotal++;
					if(lim.hasLoaded) {
						numLoaded++;
						progress++;
					}
					else {
						progress += lim.bytesLoaded / lim.bytesTotal;
					}
				}
			}
			progress = progress / numTotal;
			return { progress:progress, numTotal:numTotal, numCurrent:numLoaded + 1 };
		}
		
		
		public function getResByUrl(url:String, clear:Boolean=false):*
		{
			var lim:LoadItemModel = _resList.getValueByKey(url);
			if(lim == null) return null;
			if(clear) _resList.removeKey(url);
			return lim.data;
		}
		
		public function getResByConfigName(configName:String, clear:Boolean=false, urlArgs:Array=null):*
		{
			var config:Object = Common.config.getResConfig(configName);
			var url:String = (urlArgs != null) ? StringUtil.substitute(config.url, urlArgs) : config.url;
			return getResByUrl(url, clear);
		}
		
		
		public function getLoadItemModel(url:String):LoadItemModel
		{
			var lim:LoadItemModel = _loadList.getValueByKey(url);
			if(lim != null) return lim;
			
			lim = _loadingList.getValueByKey(url);
			if(lim != null) return lim;
			
			lim = _resList.getValueByKey(url);
			if(lim != null) return lim;
			
			return null;
		}
		
		public function hasResLoaded(url:String):Boolean
		{
			return _resList.getValueByKey(url) != null;
		}
		
		public function get running():Boolean
		{
			return _loadingList.length > 0 && !_isStop;
		}
		
		public function get isSecretly():Boolean
		{
			for(var i:int = 0; i < _loadingList.length; i++) {
				var lim:LoadItemModel = _loadingList.getValueByIndex(i);
				if(!lim.isSecretly) return false;
			}
			return true;
		}
		//
	}
}

class Enforcer {}