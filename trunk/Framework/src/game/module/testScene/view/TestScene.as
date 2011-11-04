package game.module.testScene.view
{
	import flash.events.MouseEvent;
	
	import reign.common.Common;
	import reign.components.List;
	import reign.components.Page;
	import reign.components.RichText;
	import reign.components.ScrollBar;
	import reign.core.Scene;
	import reign.data.HashMap;
	import reign.utils.StringUtil;
	import reign.utils.UbbUtil;

	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		/**单例的实例*/
		public static var instance:TestScene;
		
		public var list:List;
		public var page:Page;
		public var vsb:ScrollBar;
		public var hsb:ScrollBar;
		
		public var richText:RichText;
		
		
		public function TestScene()
		{
			super();
			instance = this;
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
//			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			list.itemRendererClass = TestItem;
			list.selectMode = List.SELECT_MODE_KEY;
			list.page = page;
			
			
			richText = new RichText();
			richText.width = 200;
			richText.color = 0xFFFFFF;
			richText.height = 999;
			this.addChild(richText);
			
			
			var str:String = "asdasd<color=0xFF0000>内容</color>ccc<color=0x00FF00>ddd</color>eee" +
				"<link=testLink>链接内容</link>fff<img=图标标识></img>";
			
			richText.beginParagraph();
			richText.appendText(str);
			richText.endParagraph();
			
			var content:Array = UbbUtil.stringToList(str);
			content = content.concat();
		}
		
		
		private function timerHandler():void
		{
			var add:Boolean;
			
			var data:HashMap = new HashMap();
//			for(var i:int = 0; i < Math.random() * 10 + 20; i++)
			for(var i:int = 0; i < 200; i++)
			{
				data.add(i, "aa" + i, "bb" + i);
				
				if(!add && Math.random() * 30 > 28) {
					data.add(999, "99d");
					add = true;
				}
			}
			list.data = data;
			
			vsb.update();
			hsb.update();
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			
		}
		//
	}
}