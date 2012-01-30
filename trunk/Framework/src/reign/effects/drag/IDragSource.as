package reign.effects.drag
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * 拖动源接口
	 * @author LOLO
	 */
	public interface IDragSource extends IEventDispatcher
	{
		/**
		 * 获取绘制源
		 * DragDrop在鼠标按下时，将会调用该方法
		 * @return 
		 */
		function get drawSource():DisplayObject;
		
		
		/**
		 * 是否可以拖动
		 */
		function get dragEnabled():Boolean;
		function set dragEnabled(value:Boolean):void;
		
		//
	}
}