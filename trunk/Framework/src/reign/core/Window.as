package reign.core
{
	import reign.ui.ICenterDisplayObject;

	/**
	 * 窗口
	 * @author LOLO
	 */
	public class Window extends Module implements IWindow, ICenterDisplayObject
	{
		public function Window()
		{
			super();
		}
		
		/**
		 * 窗口ID
		 */
		public function set windowID(value:int):void
		{
		}
		
		public function get windowID():int
		{
			return 0;
		}
		
		
		
		/**
		 * 当前打开的面板名称
		 */
		public function set panelName(value:String):void
		{
			
		}
		
		public function get panelName():String
		{
			return null;
		}
		
		
		/**
		 * 获取居中宽度
		 * @return 
		 */
		public function get centerWidth():uint
		{
			return width;
		}
		
		/**
		 * 获取居中高度
		 * @return 
		 */
		public function get centerHeight():uint
		{
			return height;
		}
		//
	}
}