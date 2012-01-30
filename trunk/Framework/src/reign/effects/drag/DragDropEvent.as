package reign.effects.drag
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	
	/**
	 * 拖放事件
	 * @author LOLO
	 */
	public class DragDropEvent extends Event
	{
		/**开始拖动*/
		public static const DRAG_START:String = "dragStart";
		/**拖动中（移动）*/
		public static const DRAG_MOVE:String = "dragMove";
		/**拖动停止*/
		public static const DRAG_END:String = "dragEnd";
		/**拖动停放到某个对象上*/
		public static const DRAG_DROP:String = "dragDrop";
		
		
		/**拖动的目标*/
		public var dragSource:InteractiveObject;
		/**拖动目标附带的值*/
		public var data:*;
		/**拖动停放的目标*/
		public var dropTarget:DisplayObject;
		/**事件发生点在舞台的水平坐标*/
		public var stageX:int;
		/**事件发生点在舞台的垂直坐标*/
		public var stageY:int;
		
		
		public function DragDropEvent(type:String, dragSource:InteractiveObject, dropTarget:DisplayObject=null, data:*=null, stageX:int=0, stageY:int=0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.dragSource = dragSource;
			this.dropTarget = dropTarget;
			this.data = data;
			this.stageX = stageX;
			this.stageY = stageY;
		}
		//
	}
}