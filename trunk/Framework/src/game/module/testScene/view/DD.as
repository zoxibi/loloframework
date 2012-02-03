package game.module.testScene.view
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import reign.components.Label;
	import reign.effects.drag.IDragTarget;
	import reign.effects.drag.IDropTarget;
	import reign.utils.RandomUtil;
	
	public class DD extends Sprite implements IDragTarget, IDropTarget
	{
		public var label:Label;
		public var color:uint;
		
		
		public function DD(color:uint)
		{
			super();
			this.color = color;
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest("http://www.qqtouxiang888.com/uploads/allimg/100903/1010292618-9.jpg"));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, test);
			this.addChild(loader);
			
			label = new Label();
			label.stroke = "0";
			label.color = 0xFFFFFF;
			label.text = String(int(RandomUtil.getBetween(1, 10)));
			label.x = 43;
			this.addChild(label);
			
			
			draw();
		}
		
		private function test(event:Event):void
		{
			var loader:Loader = Loader(event.target.loader);
			loader.x = loader.y = 1;
			loader.width = loader.height = 48;
		}
		
		
		public function draw():void
		{
//			graphics.beginFill(color);
//			graphics.drawRect(0, 0, 50, 50);
//			graphics.endFill();
		}
		
		
		/**
		 * 获取源（绘制，鼠标点击）
		 * @return 
		 */
		public function get source():DisplayObject
		{
			return this;
		}
		
		
		/**
		 * 是否可以拖动
		 */
		public function get dragEnabled():Boolean
		{
			return true;
		}
		
		
		/**
		 * 拖动目标附带的数据
		 */
		public function get dragTargetData():*
		{
			return color;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		/**
		 * 是否可以停放
		 */
		public function get dropEnabled():Boolean
		{
			return true;
		}
		
		
		/**
		 * 停放目标附带的数据
		 */
		public function get dropTargetData():*
		{
			return color;
		}
		
		/**
		 * 拖动目标从移进来了
		 * @param dragTarget
		 */
		public function dragIn(dragTarget:IDragTarget):void
		{
			trace("移入", this.name, dragTarget["name"]);
		}
		
		/**
		 * 拖动目标从身上移开
		 * @param dragTarget
		 */
		public function dragOut(dragTarget:IDragTarget):void
		{
			trace("移开", this.name, dragTarget["name"]);
		}
		
		/**
		 * 有拖动目标申请停放
		 * @param dragTarget
		 */
		public function applyDrop(dragTarget:IDragTarget):void
		{
			trace("申请", this.name, dragTarget["name"]);
		}
		//
	}
}