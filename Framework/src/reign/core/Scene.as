package reign.core
{
	/**
	 * 场景
	 * @author LOLO
	 */
	public class Scene extends Module implements IScene
	{
		/**场景ID*/
		protected var _sceneID:int;
		
		
		
		/**
		 * 场景ID
		 */
		public function set sceneID(value:int):void
		{
			_sceneID = value;
		}
		
		public function get sceneID():int
		{
			return _sceneID;
		}
		//
	}
}