package game.module.loginScene.view
{
	import lolo.common.Common;
	import lolo.components.BaseButton;
	import lolo.components.Label;
	import lolo.components.ToolTip;
	import lolo.events.components.ToolTipEvent;
	import lolo.utils.AutoUtil;
	
	/**
	 * 组合框，列表，子项
	 * @author LOLO
	 */
	public class ComboBoxItemRenderer extends BaseButton
	{
		public static var _config:XML = new XML( Common.loader.getResByConfigName("loginSceneConfig").comboBoxItemRenderer );
		
		
		/**显示文本*/
		public var labelText:Label;
		
		public function ComboBoxItemRenderer()
		{
			super();
			AutoUtil.autoUI(this, _config);
			
			labelText.addEventListener(ToolTipEvent.SHOW, labelText_showToolTipHandler);
		}
		
		override public function set data(value:*):void
		{
			super.data = value;
			
			labelText.text = value;
		}
		
		
		/**
		 * 文本的tooltip有改变时
		 * @param event
		 */
		private function labelText_showToolTipHandler(event:ToolTipEvent):void
		{
			ToolTip.register(this, event.toolTip);
		}
		
		
		/**
		 * 在被选中时，ComboBox.label的内容
		 * @return 
		 */
		public function get label():String
		{
			return _data;
		}
		//
	}
}