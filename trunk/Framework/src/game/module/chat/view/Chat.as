package game.module.chat.view
{
	import flash.display.SimpleButton;
	
	import reign.common.Common;
	import reign.core.Module;

	/**
	 * 聊天模块
	 * @author LOLO
	 */
	public class Chat extends Module implements IChat
	{
		/**单例的实例*/
		public static var instance:Chat;
		
		/**修改频道按钮*/
		public var changeChannelBtn:SimpleButton;
		/**修改聊天框尺寸按钮*/
		public var changeSizeBtn:SimpleButton;
		
		
		public function Chat()
		{
			super();
			instance = this;
			initUI(Common.loader.getXML(Common.language.getLanguage("020301")));
			
		}
		//
	}
}