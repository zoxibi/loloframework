package game.net
{
	import com.adobe.serialization.json.AdobeJSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import lolo.common.Common;
	import lolo.components.AlertText;
	import lolo.data.RequestModel;
	import lolo.net.IService;
	import lolo.ui.Console;
	
	/**
	 * 与后台通信的HTTP服务
	 * @author LOLO
	 */
	public class HttpService implements IService
	{
		/**单例的实例*/
		private static var _instance:HttpService;
		/**请求的代号（唯一标识符）*/
		private static var _token:Number = 0;
		
		/**通信实例列表（RequestModel为key）*/
		private var _loaderList:Dictionary;
		/**用于长连接*/
		private var _longConnect:URLStream;
		/**长连接当前要读取的数据长度*/
		private var _lcDataLength:int = 0;
		
		
		
		/**
		 * 获取单例的实例
		 * @return 
		 */
		public static function getInstance():HttpService
		{
			if(_instance == null) _instance = new HttpService(new Enforcer());
			return _instance;
		}
		
		
		
		public function HttpService(enforcer:Enforcer)
		{
			super();
			if(enforcer == null) {
				throw new Error("请通过Common.service获取实例");
				return;
			}
			
			_loaderList = new Dictionary();
			
			_longConnect = new URLStream();
			_longConnect.addEventListener(ProgressEvent.PROGRESS, longConnect_progressHandler);
			_longConnect.addEventListener(Event.COMPLETE, longConnectReconnect);
			_longConnect.addEventListener(IOErrorEvent.IO_ERROR, longConnectReconnect);
			_longConnect.addEventListener(SecurityErrorEvent.SECURITY_ERROR, longConnectReconnect);
		}
		
		
		public function send(rm:RequestModel, data:Object=null, callback:Function=null, alertError:Boolean=true):void
		{
			if(rm.modal) Common.ui.requesModal.startModal(rm);
			rm.token = ++_token;
			
			var loader:HttpLoader = getLoader(rm);
			loader.close();
			loader.callback = callback;
			loader.alertError = alertError;
			if(alertError) loader.mousePoint = new Point(Common.stage.mouseX, Common.stage.mouseY);
			
			var url:String = Common.serviceUrl + rm.command + "?t=" + rm.token;
			var request:URLRequest = new URLRequest(url);
			request.method = URLRequestMethod.POST;
			
			if(data != null)
			{
				var vars:URLVariables = new URLVariables();
				for(var key:String in data) vars[key] = data[key];
				request.data = vars;
			}
			
			loader.load(request);
		}
		
		
		public function setTimeout(rm:RequestModel):void
		{
			getLoader(rm).close();
			var msg:String = Common.language.getLanguage("010303");
			callback(rm, false, {msg:msg}, true);
		}
		
		
		
		/**
		 * 获取数据完成
		 * @param event
		 */
		private function completeHandler(event:Event):void
		{
			var rm:RequestModel = (event.target as HttpLoader).requestModel;
			var bytes:ByteArray = event.target.data as ByteArray;
			var msg:String;
			
			//解压数据
			if(Common.config.getConfig("decompress") == "true")
			{
				try {
					bytes.uncompress();
				}
				catch(error:Error) {
					msg = Common.language.getLanguage("010301");
					callback(rm, false, {msg:msg});
					return;
				}
			}
			
			//转换数据
			var data:Object;
			try {
				data = AdobeJSON.decode(bytes.toString());
			}
			catch(error:Error) {
				msg = Common.language.getLanguage("010302");
				callback(rm, false, {msg:msg});
				return;
			}
			
			var state:int = data.state;
			//操作成功
			if(state == 1)
			{
				callback(rm, true, data);
			}
			
			//操作异常
			else if(state == 2)
			{
				msg = Common.language.getLanguage("010304", data.errorCode);
				callback(rm, false, {msg:msg});
			}
			
			//操作失败
			else {
				callback(rm, false, data);
			}
		}
		
		/**
		 * 获取数据失败
		 * @param event
		 */
		private function errorHandler(event:Event):void
		{
			var msg:String = Common.language.getLanguage("010305");
			callback(event.target.requestModel, false, {msg:msg});
		}
		
		
		
		/**
		 * 请求已有结果，进行回调
		 * @param rm 通信接口模型
		 * @param success 通信是否成功
		 * @param data 数据
		 * @param timeout 通信是否超时
		 */
		private function callback(rm:RequestModel, success:Boolean, data:Object, timeout:Boolean=false):void
		{
			var loader:HttpLoader = getLoader(rm);
			data.timeout = timeout;
			
			if(rm.modal) Common.ui.requesModal.endModal(rm);
			if(timeout) loader.close();
			
			if(!success && loader.alertError)
			{
				var alertText:AlertText = AlertText.getInstance("serviceError");
				alertText.x = loader.mousePoint.x;
				alertText.y = loader.mousePoint.y;
				alertText.show(data.msg);
			}
			
			if(loader.callback != null) loader.callback(success, data);
		}
		
		
		
		
		/**
		 * 长连接收到数据
		 * @param event
		 */
		private function longConnect_progressHandler(event:ProgressEvent=null):void
		{
			//目前还没有读到数据长度
			if(_lcDataLength == 0) {
				if(_longConnect.bytesAvailable >= 4) {
					_lcDataLength = _longConnect.readInt();
				}
				else {
					return;
				}
			}
			
			//缓冲区的数据长度不够
			if(_longConnect.bytesAvailable < _lcDataLength) return;
			
			
			//读取数据
			var str:String = _longConnect.readUTFBytes(_lcDataLength);
			Console.trace("HTTP长连接收到数据：", str);
			
			
			//缓冲区还有数据，继续读
			_lcDataLength = 0;
			if(_longConnect.bytesAvailable > 0) longConnect_progressHandler();
		}
		
		
		/**
		 * 长连接重连
		 * @param event
		 */
		public function longConnectReconnect(event:Event=null):void
		{
			var str:String = (event != null) ? (event.type + "  之前剩余数据长度：" + _longConnect.bytesAvailable) : "";
			Console.trace("HTTP长连接重连", str);
		}
		
		
		
		/**
		 * 通过rm获取对应的HttpLoader
		 * @param rm
		 */
		private function getLoader(rm:RequestModel):HttpLoader
		{
			if(_loaderList[rm] == null)
			{
				var loader:HttpLoader = new HttpLoader(rm);
				loader.addEventListener(Event.COMPLETE, completeHandler);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				_loaderList[rm] = loader;
			}
			return _loaderList[rm];
		}
		//
	}
}


class Enforcer{}