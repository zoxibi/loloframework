package lolo.ui
{
	import lolo.core.IContainer;
	/**
	 * 加载条
	 * @author LOLO
	 */
	public interface ILoadBar extends IContainer
	{
		/**
		 * 是否侦听Common.loader资源加载事件
		 */
		function set isListener(value:Boolean):void;
		function get isListener():Boolean;
		
		/**
		 * 显示文本内容
		 */
		function set text(value:String):void;
		function get text():String;
		
		/**
		 * 当前关注的组
		 */
		function set group(value:String):void;
		function get group():String;
		//
	}
}