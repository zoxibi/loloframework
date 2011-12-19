package game.module.loginScene.view
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import game.common.ModuleName;
	import game.module.core.events.ChangeServiceTypeEvent;
	import game.module.loginScene.controls.LoginSceneController;
	import game.module.loginScene.events.LoginEvent;
	import game.module.loginScene.events.RegisterEvent;
	
	import reign.common.Common;
	import reign.common.Constants;
	import reign.components.Button;
	import reign.components.ComboBox;
	import reign.components.InputText;
	import reign.components.ItemGroup;
	import reign.core.Scene;
	import reign.data.HashMap;
	import reign.events.components.ItemEvent;
	import reign.mvc.control.MvcEventDispatcher;
	import reign.utils.Validator;

	/**
	 * 登录场景
	 * @author LOLO
	 */
	public class LoginScene extends Scene implements ILoginScene
	{
		/**单例的实例*/
		public static var instance:LoginScene;
		
		/**帐号输入框*/
		public var usernameIT:InputText;
		/**密码输入框*/
		public var passwordIT:InputText;
		/**后端服务组合框*/
		public var serviceCMB:ComboBox;
		/**连接类型组*/
		public var typeGroup:ItemGroup;
		/**连接按钮*/
		public var connBtn:Button;
		/**注册按钮*/
		public var registerBtn:Button;
		/**登录按钮*/
		public var loginBtn:Button;
		
		
		private var _so:SharedObject;
		
		
		public function LoginScene()
		{
			super();
			instance = this;
			new LoginSceneController();
			initUI(Common.loader.getXML(Common.language.getLanguage("020204")));
			
			serviceCMB.list.itemRendererClass = ComboBoxItemRenderer;
			
			
			//显示默认的帐号密码
			_so = SharedObject.getLocal("LOLO_Framework");
			if(_so.data.username != null) usernameIT.text = _so.data.username;
			if(_so.data.password != null) passwordIT.text = _so.data.password;
			
			//设置默认的连接方式
			typeGroup.addEventListener(ItemEvent.ITEM_SELECTED, typeGroup_itemSelectedHandler);
			typeGroup.selectItemByIndex((_so.data.serviceType != null) ? _so.data.serviceType : 0);
			
			//显示默认的ServiceUrl
			serviceCMB.label = Common.serviceUrl;
			
			//显示服务器列表
			var arr:Array = Common.config.getConfig("serviceList").split(",");
			var serviceList:HashMap = new HashMap();
			for(var i:int = 0; i < arr.length; i++)
			{
				serviceList.add(arr[i], arr[i]);
			}
			serviceCMB.listData = serviceList;
			serviceCMB.list.addEventListener(ItemEvent.ITEM_SELECTED, setServiceUrl);
			connBtn.addEventListener(MouseEvent.CLICK, setServiceUrl);
			
			
			registerBtn.addEventListener(MouseEvent.CLICK, registerBtn_clickHandler);
			loginBtn.addEventListener(MouseEvent.CLICK, loginBtn_clickHandler);
		}
		
		
		
		/**
		 * 服务类型有改变
		 * @param event
		 */
		private function typeGroup_itemSelectedHandler(event:ItemEvent):void
		{
			_so.data.serviceType = event.item.index;
			
			var url:String;
			if(event.item.data == Constants.SERVICE_TYPE_SOCKET) {
				url = (_so.data.socketUrl != null) ? _so.data.socketUrl : Common.config.getConfig("socketServiceUrl");
			}
			else {
				url = (_so.data.httpUrl != null) ? _so.data.httpUrl : Common.config.getConfig("httpServiceUrl");
			}
			serviceCMB.label = url;
			
			MvcEventDispatcher.dispatch(ModuleName.CORE, new ChangeServiceTypeEvent(event.item.data, url));
		}
		
		
		/**
		 * 设置后台服务器的网络地址
		 * @param event
		 */
		private function setServiceUrl(event:Event=null):void
		{
			if(serviceCMB.label == Common.serviceUrl) return;
			if(event as ItemEvent && (event as ItemEvent).item == null) return;
			
			var url:String = serviceCMB.label;
			(Common.serviceType == Constants.SERVICE_TYPE_SOCKET) ? (_so.data.socketUrl = url) : (_so.data.httpUrl = url);
			
			MvcEventDispatcher.dispatch(ModuleName.CORE, new ChangeServiceTypeEvent(Common.serviceType, url));
		}
		
		
		
		
		/**
		 * 在帐号输入框，或密码输入框按下按键
		 * @param event
		 */
		private function inputText_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == 13)//回车
			{
				if(event.currentTarget == usernameIT) {
					if(stage) stage.focus = passwordIT;
				}
				else {
					if(stage) stage.focus = this;
					loginBtn_clickHandler();
				}
			}
		}
		
		
		
		/**
		 * 点击注册按钮
		 * @param event
		 */
		private function registerBtn_clickHandler(event:MouseEvent):void
		{
			if(Validator.noSpace(usernameIT.text) && Validator.noSpace(passwordIT.text))
			{
				MvcEventDispatcher.dispatch(ModuleName.SCENE_LOGIN, new RegisterEvent(usernameIT.text, passwordIT.text));
			}
		}
		
		/**
		 * 点击登录按钮
		 * @param event
		 */
		private function loginBtn_clickHandler(event:MouseEvent=null):void
		{
			if(Validator.noSpace(usernameIT.text) && Validator.noSpace(passwordIT.text))
			{
				MvcEventDispatcher.dispatch(ModuleName.SCENE_LOGIN, new LoginEvent(usernameIT.text, passwordIT.text));
			}
		}
		
		
		
		override protected function startup():void
		{
			stage.focus = usernameIT;
			usernameIT.addEventListener(KeyboardEvent.KEY_DOWN, inputText_keyDownHandler);
			passwordIT.addEventListener(KeyboardEvent.KEY_DOWN, inputText_keyDownHandler);
		}
		
		
		override protected function reset():void
		{
			usernameIT.removeEventListener(KeyboardEvent.KEY_DOWN, inputText_keyDownHandler);
			passwordIT.removeEventListener(KeyboardEvent.KEY_DOWN, inputText_keyDownHandler);
		}
		//
	}
}