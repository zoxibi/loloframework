package game.module.testScene.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import lolo.components.ImageLoader;
	import lolo.effects.drag.DragDrop;
	import lolo.effects.drag.DragDropEvent;
	import lolo.effects.drag.IDragTarget;
	import lolo.effects.drag.IDropTarget;
	
	public class TestItem extends Sprite implements IDragTarget, IDropTarget
	{
		private var _pic:String;
		private var _img:ImageLoader;
		private var _dragDrop:DragDrop;
		
		
		public function TestItem(pic:String)
		{
			super();
			
			_img = new ImageLoader();
			_img.width = _img.height = 100;
			_img.path = "assets/{resVersion}/img/background/{0}.jpg";
			this.addChild(_img);
			
			this.pic = pic;
			_dragDrop = new DragDrop(this);
		}
		
		public function set pic(value:String):void
		{
			_pic = value;
			_img.fileName = pic;
		}
		public function get pic():String { return _pic; }
		
		
		
		public function get source():DisplayObject
		{
			return this;
		}
		
		public function get dragEnabled():Boolean
		{
			return true;
		}
		
		public function get dragTargetData():*
		{
			return _pic;
		}
		
		public function get dropEnabled():Boolean
		{
			return true;
		}
		
		public function get dropTargetData():*
		{
			return _pic;
		}
		
		public function dragIn(dragTarget:IDragTarget):void
		{
		}
		
		public function dragOut(dragTarget:IDragTarget):void
		{
		}
		
		public function applyDrop(dragTarget:IDragTarget):void
		{
			var item:TestItem = dragTarget as TestItem;
			var pic:String = item.pic;
			item.pic = this.pic;
			this.pic = pic;
		}
		//
	}
}