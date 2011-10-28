package reign.core
{
	/**
	 * 场景
	 * @author LOLO
	 */
	public interface IScene extends IModule
	{
		/**
		 * 场景ID
		 */
		function set sceneID(value:int):void;
		function get sceneID():int;
	}
}