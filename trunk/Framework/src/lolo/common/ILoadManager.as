package lolo.common
{
	import flash.events.IEventDispatcher;
	
	import lolo.data.LoadItemModel;
	
	/**
	 * 加载管理器
	 * @author LOLO
	 */
	public interface ILoadManager extends IEventDispatcher
	{
		/**
		 * 添加一个加载项模型到加载队列中
		 * @param lim 加载项模型
		 * @param isSort 是否对需要加载的文件列表进行排序
		 * @return 如果文件已在加载列表，或者已经加载完毕，将返回原先的加载项模型，并同步isSecretly、priority和group。否则返回参数lim传入的加载项模型
		 */
		function add(lim:LoadItemModel, isSort:Boolean=false):LoadItemModel;
		
		
		/**
		 * 开始加载所有项目（包括暗中加载和正常加载）
		 * @param group 所关心的组，如果该组没有文件需要加载，您将会立即获得该组的LoadEvent.GROUP_COMPLETE事件，或触发回调
		 * @param callback
		 */
		function start(group:String="public", callback:Function=null):void;
		
		
		/**
		 * 停止所有项目的加载（包括暗中加载和正常加载），以及正在加载的项目
		 */
		function stop():void;
		
		
		/**
		 * 通过组的名称来清除该组的加载队列（以及加载中的项目）。默认值all，表示清除所有加载队列
		 * @param group
		 */
		function clearLoadList(group:String="all"):void;
		
		
		/**
		 * 通过url获取已加载好的资源。如果还加载完成，则返回null
		 * @param url
		 * @param clear 获取后是否清除
		 * @return	RES_TYPE_CLA 返回：true
		 * 			RES_TYPE_IMG 返回：BitmapData
		 * 			RES_TYPE_SWF 返回：swf内容本身
		 * 			RES_TYPE_ZIP 返回：ZipReader
		 * 			RES_TYPE_XML 返回：XML
		 */
		function getResByUrl(url:String, clear:Boolean=false):*;
		
		
		/**
		 * 通过配置文件(ResConfig)中的名称，获取已加载好的资源
		 * @param configName
		 * @param clear 获取后是否清除
		 * @param urlArgs url的替换参数
		 * @return 见getResByUrl()方法
		 */
		function getResByConfigName(configName:String, clear:Boolean=false, urlArgs:Array=null):*;
		
		
		/**
		 * 通过url获取已创建的加载项数据模型。如果还未创建，则返回null
		 * @param url
		 * @return 
		 */
		function getLoadItemModel(url:String):LoadItemModel;
		
		
		/**
		 * 通过url检测资源是否已经加载完成
		 * @param url
		 */
		function hasResLoaded(url:String):Boolean;
		
		
		/**
		 * 获取某个组的加载进度
		 * @param group
		 * @return { progress:0~1, numTotal:该组需要加载的文件总数, numCurrent:当前正在加载文件的编号 }
		 */
		function getGroupProgress(group:String="public"):Object;
		
		
		/**
		 * 获取某个组的文件是否已经全部加载完毕
		 * @param group
		 * @return 
		 */
		function getGroupLoaded(group:String):Boolean;
		
		
		/**
		 * 加载器是否正在运行中
		 * @return 
		 */
		function get running():Boolean;
		
		
		/**
		 * 是否为暗中加载状态（正在加载的文件都是暗中加载项）
		 * @return 
		 */
		function get isSecretly():Boolean;
	}
	//
}