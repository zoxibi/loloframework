package game.module.testScene.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import reign.effects.drag.IDragTarget;
	import reign.effects.drag.IDropTarget;
	
	public class DD extends Sprite implements IDragTarget, IDropTarget
	{
		
		public var color:uint;
		
		
		public function DD(color:uint)
		{
			super();
			this.color = color;
			draw();
		}
		
		
		public function draw():void
		{
			graphics.beginFill(color);
			graphics.drawRect(0, 0, 50, 50);
			graphics.endFill();
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