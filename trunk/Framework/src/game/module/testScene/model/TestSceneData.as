package game.module.testScene.model
{
	import reign.utils.bind.Data;
	
	/**
	 * 【测试场景】数据
	 * @author LOLO
	 */
	public class TestSceneData extends Data
	{
		/**单例的实例*/
		private static var _instance:TestSceneData = null;
		/**获取实例*/
		public static function getInstance():TestSceneData
		{
			if(_instance == null) _instance = new TestSceneData();
			return _instance;
		}
		
		
		
		
		/**数据更新*/
		private var _update:int;
		
		
		
		/**数据更新*/
		public function set update(value:int):void { changeValue("update", "_update", value); }
		public function get update():int { return _update; }
		
		
		
		/**获取属性的值(继承时，请拷贝该函数到继承类中，并标记为override)*/
		override protected function getProperty(name:String):* { return this[name]; }
		
		/**设置属性的值 (继承时，请拷贝该函数到继承类中，并标记为override)*/
		override protected function setProperty(name:String, value:*):void { this[name] = value; }
		//
	}
}