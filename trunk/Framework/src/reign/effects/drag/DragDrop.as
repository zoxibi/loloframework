package reign.effects.drag
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import reign.common.Common;
	import reign.common.Constants;
	
	/**
	 * 拖放效果
	 * @author LOLO
	 */
	public class DragDrop extends Bitmap
	{
		/**拖动的目标*/
		private var _dragTarget:IDragTarget;
		/**当前移入的停放目标*/
		private var _dropTarget:IDropTarget;
		/**鼠标按下的点*/
		private var _mouseDownPoint:Point;
		
		
		public function DragDrop(dragTarget:IDragTarget=null)
		{
			super();
			this.dragTarget = dragTarget;
			this.alpha = 0.8;
		}
		
		
		
		/**
		 * 鼠标按下拖动目标
		 * @param event
		 */
		private function dragTarget_mouseDownHandler(event:MouseEvent):void
		{
			_mouseDownPoint = new Point(_dragTarget.source.mouseX, _dragTarget.source.mouseY);
			Common.stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			Common.stage.addEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		/**
		 * 鼠标在舞台移动
		 * @param event
		 */
		private function stage_mouseMoveHandler(event:MouseEvent):void
		{
			if(!event.buttonDown) return;
			
			if(!_dragTarget.dragEnabled) {
				if(bitmapData != null) {
					bitmapData.dispose();
					bitmapData = null;
				}
				return;
			}
			
			var dropTarget:IDropTarget = getDropTarget();
			//开始拖动
			if(bitmapData == null) {
				drawDragTarget();
				dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_START, _dragTarget, dropTarget));
			}
			else {
				dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_MOVE, _dragTarget, dropTarget));
			}
			
			this.x = event.stageX - _mouseDownPoint.x;
			this.y = event.stageY - _mouseDownPoint.y;
			event.updateAfterEvent();
		}
		
		/**
		 * 鼠标在舞台释放
		 * @param event
		 */
		private function stage_mouseUpHandler(event:MouseEvent):void
		{
			Common.stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			Common.stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
			
			Common.ui.removeChildToLayer(this, Constants.LAYER_NAME_ALERT);
			if(bitmapData != null) {
				bitmapData.dispose();
				bitmapData = null;
			}
			
			var dropTarget:IDropTarget = getDropTarget();
			//是在停放目标上释放鼠标的
			if(dropTarget != null) {
				_dropTarget = null;
				
				//调用移入停放目标的【移开】方法
				dropTarget.dragOut(_dragTarget);
				dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_OUT, _dragTarget, dropTarget));
				
				//向停放目标【申请停放】
				dropTarget.applyDrop(_dragTarget);
				dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_DROP, _dragTarget, dropTarget));
			}
			else {
				dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_END, _dragTarget));	
			}
		}
		
		
		
		/**
		 * 获取当前鼠标指针下，可以停放的目标，并记录该目标
		 * @return 
		 */
		private function getDropTarget():IDropTarget
		{
			//从最上层开始取出显示对象
			var childs:Array = Common.stage.getObjectsUnderPoint(new Point(Common.stage.mouseX, Common.stage.mouseY));
			childs.reverse();
			
			var dropTarget:IDropTarget;
			var parent:DisplayObjectContainer;
			for(var i:int = 0; i < childs.length; i++)
			{
				//显示对象是停放目标
				if(childs[i] is IDropTarget) {
					dropTarget = childs[i];
				}
				else {
					//查找他的父级是否为停放目标
					parent = childs[i].parent;
					while(parent != null)
					{
						if(parent is IDropTarget) {
							dropTarget = parent as IDropTarget;
							break;
						}
						parent = parent.parent;
					}
				}
				
				//已经找到了停放目标
				if(dropTarget != null) break;
			}
			
			//停放目标有改变
			if(dropTarget != _dropTarget) {
				//调用上次移入停放目标的【移开】方法
				if(_dropTarget != null) {
					_dropTarget.dragOut(_dragTarget);
					dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_OUT, _dragTarget, _dropTarget));
				}
				
				_dropTarget = dropTarget;
				//调用移入停放目标的【移入】方法
				if(_dropTarget != null) {
					_dropTarget.dragIn(_dragTarget);
					dispatchEvent(new DragDropEvent(DragDropEvent.DRAG_IN, _dragTarget, _dropTarget));
				}
			}
			
			return dropTarget;
		}
		
		
		
		
		/**
		 * 绘制拖动的目标
		 * @param source
		 */
		public function drawDragTarget():void
		{
			if(_dragTarget.source == null) return;
			
			if(bitmapData != null) bitmapData.dispose();
			bitmapData = new BitmapData(_dragTarget.source.width, _dragTarget.source.height, true, 0);
			bitmapData.draw(_dragTarget.source);
			
			Common.ui.addChildToLayer(this, Constants.LAYER_NAME_ALERT);
		}
		
		
		/**
		 * 拖动的目标
		 */
		public function set dragTarget(value:IDragTarget):void
		{
			if(_dragTarget != null) {
				_dragTarget.source.removeEventListener(MouseEvent.MOUSE_DOWN, dragTarget_mouseDownHandler);
			}
			
			_dragTarget = value;
			if(_dragTarget != null) {
				_dragTarget.source.addEventListener(MouseEvent.MOUSE_DOWN, dragTarget_mouseDownHandler);
			}
		}
		public function get dragTarget():IDragTarget { return _dragTarget; }
		
		
		
		
		/**
		 * 用于清理引用，释放内存
		 * 在丢弃该对象时，需要主动调用该方法
		 */
		public function dispose():void
		{
			if(bitmapData != null) {
				bitmapData.dispose();
				bitmapData = null;
			}
			
			dragTarget = null;
		}
		//
	}
}