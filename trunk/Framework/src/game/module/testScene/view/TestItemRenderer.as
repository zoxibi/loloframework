package game.module.testScene.view
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import reign.components.BaseButton;
	import reign.components.Button;
	import reign.components.ImageLoader;
	import reign.components.ToolTip;
	import reign.events.components.ToolTipEvent;
	import reign.utils.AutoUtil;
	
	/**
	 * 组合框，列表，子项
	 * @author LOLO
	 */
	public class TestItemRenderer extends BaseButton
	{
		/**头像*/
		public var picLoader:ImageLoader;
		/**徽章*/
		public var badgeBitmap:Bitmap;
		/**移出队伍按钮*/
		public var removeBtn:Button;
		
		
		override public function set data(value:*):void
		{
			super.data = value;
			
			picLoader.fileName = value.pic;
			badgeBitmap.bitmapData = getBadgeBitmapData(value.badge);
			removeBtn.addEventListener(MouseEvent.CLICK, removeBtn_clickHandler);
			ToolTip.register(picLoader, "点击查看玩家详情");
		}
		
		
		override public function dispose():void
		{
			picLoader.unload();
			badgeBitmap.bitmapData.dispose();
			removeBtn.removeEventListener(MouseEvent.CLICK, removeBtn_clickHandler);
			ToolTip.unregister(picLoader);
		}
		
		
		
		private function removeBtn_clickHandler(event:MouseEvent):void
		{
			
		}
		
		private function getBadgeBitmapData(value:*):void
		{
			
		}
		//
	}
}