package game.module.chat.view
{
	import reign.common.Common;
	import reign.components.RichText;
	import reign.core.Module;
	import reign.events.components.RichTextEvent;
	import reign.utils.AutoUtil;

	/**
	 * 聊天模块
	 * @author LOLO
	 */
	public class Chat extends Module implements IChat
	{
		/**单例的实例*/
		public static var instance:Chat;
		
		
		public var richText:RichText;
		
		
		public function Chat()
		{
			super();
			instance = this;
			initUI(Common.loader.getXML(Common.language.getLanguage("020301")));
			
			richText = new RichText();
			richText.color = 0xFF0000;
			this.addChild(richText);
			richText.addEventListener(RichTextEvent.CLICK_LINK, richText_clickLinkHandler);
			
			
			richText.appendText("的份额司法所地方斯蒂芬斯蒂芬斯蒂芬斯");
			richText.appendGraphic(AutoUtil.getInstance("chat.smileys.CiYa"));
			richText.appendText("的份额司法所地方斯蒂芬斯蒂芬rt斯蒂芬斯蒂芬斯蒂芬", {color:0x999999});
			richText.appendLinkText("仿佛份额", "aaa");
			richText.appendLinkText("asdw", "BBB");
			richText.endParagraph();
			
			
			richText.appendText("的份额司法所地方斯蒂芬斯蒂芬斯蒂芬斯");
			richText.appendText("的份额司法所地方斯蒂芬斯蒂芬rt斯蒂芬斯蒂芬斯蒂芬", {color:0x999999});
			richText.appendLinkText("地方see", "ccc");
			richText.appendGraphic(AutoUtil.getInstance("chat.smileys.KeAi"));
			richText.appendLinkText("岁的法国宫廷", "ddd");
			richText.endParagraph();
			
			richText.selectable = true;
			richText.width = 170;
			richText.height = 900;
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 1000, 600);
			graphics.endFill();
		}
		
		
		private function richText_clickLinkHandler(event:RichTextEvent):void
		{
			trace(event.data);
		}
		//
	}
}