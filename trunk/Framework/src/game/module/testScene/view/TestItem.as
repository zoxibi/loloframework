package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import reign.components.ItemRenderer;
	import reign.components.Label;

	/**
	 * 
	 * @author LOLO
	 * 
	 */	
	public class TestItem extends ItemRenderer
	{
		public var color:uint;
		public var label:Label;
		
		public function TestItem()
		{
			super();
			
			color = (0xFFFFFF - 0x999999) * Math.random() + 0x888888;
			outHandler(null);
			
			label = new Label();
			label.x = label.y = 10;
			label.color = 0xFFFFFF;
			this.addChild(label);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		
		private function overHandler(event:MouseEvent):void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, 80, 50);
			graphics.endFill();
		}
		
		private function outHandler(event:MouseEvent):void
		{
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 80, 50);
			graphics.endFill();
		}
		
		override public function set data(value:*):void
		{
			super.data = value;
			
			if(value == 999) label.text = "ok";
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			label.text = value ? "selected" : "";
			
		}
		//
	}
}