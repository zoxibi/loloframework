package reign.effects.drag
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 停放目标接口
	 * @author LOLO
	 */
	public interface IDropTarget extends IEventDispatcher
	{
		/**
		 * 是否可以停放
		 */
		function get dropEnabled():Boolean;
		function set dropEnabled(value:Boolean):void;
		
		//
	}
}