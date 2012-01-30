package game.module.testScene.view
{
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import game.module.testScene.model.TestSceneData;
	
	import reign.common.Common;
	import reign.components.Alert;
	import reign.components.ComboBox;
	import reign.components.List;
	import reign.components.Page;
	import reign.components.RichText;
	import reign.components.ScrollBar;
	import reign.core.Scene;
	import reign.data.HashMap;
	import reign.data.RequestModel;
	import reign.utils.RTimer;
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
		public var cb:ComboBox;
		
		public var richText:RichText;
		
		private var _alert:Alert;
		
		private var _data:TestSceneData;
		
		private var _c:Sprite;
		
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			list.itemRendererClass = TestItem;
			list.selectMode = List.SELECT_MODE_KEY;
			list.page = page;
			
			
			richText = new RichText();
			richText.width = 200;
			richText.color = 0xFFFFFF;
			this.addChild(richText);
			
			richText.x = richText.y = 100;
			
			var str:String = "开始asdasd<color=0xFF0000>内容</color>ccc<color=0x00FF00>ddd</color>eee" +
				"<link=testLink>链接内容</link>fff<img=图标标识></img>";
			
			
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawRect(100, 100, 5, 5);
			s.graphics.endFill();
			this.addChild(s);
			
			var s2:Sprite = new Sprite();
			s2.graphics.beginFill(0xFF0000);
			s2.graphics.drawRect(0, 0, 30, 30);
			s2.graphics.endFill();
			
			richText.selectable = true;
			
			richText.appendText(str);
			richText.endParagraph();
			
			richText.appendText(str);
			richText.endParagraph();
			
			richText.appendGraphic(s2);
			richText.appendText(str);
			richText.endParagraph();
			
			richText.appendText(str);
			richText.endParagraph();
			
			var mask:Shape = new Shape();
			this.addChild(mask);
			mask.x = mask.y = 100;
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0, 0, 100, 100);
			mask.graphics.endFill();
			
			richText.mask = mask;
			
			var content:Array = UbbUtil.stringToList(str);
			content = content.concat();
			
			
			var hp:HashMap = new HashMap();
			hp.add({label:"AaAa"}, "AAAA", "aaaa");
			hp.add({label:"美国啊美国啊美国"}, "美国", "USA");
			hp.add({label:"BbBb"}, "BBBB", "bbbb");
			hp.add({label:"cCcC"}, "CCCC", "cccc");
			hp.add({label:"中国china"}, "中国", "china");
			cb.editable = false;
			cb.list.itemRendererClass = ComboBoxItemRenderer;
			cb.listData = hp;
			
			
			var t:RTimer = RTimer.getInstance(2000, timerHandler);
//			t.start();
			
			_c = new Sprite();
			this.addChild(_c);
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
		
		private var _a:RequestModel = new RequestModel("a");
		private var _b:RequestModel = new RequestModel("b");
		private var n:int = 0;
		
		
		private function mouseDownHandler(event:MouseEvent):void
		{
//			n++;
//			if(n % 2 == 0) {
//				Common.ui.requesModal.startModal(_a);
//				Common.ui.requesModal.startModal(_b);
//			}
//			else {
//				Common.ui.requesModal.endModal(_a);
//			}
			
			var loader:Loader;
			if(Math.random() > 0)
			{
				loader = new Loader();
				loader.load(new URLRequest("http://bbs.gigabyte.cn/space/upload/2009/07/31/795965153202.jpg"));
				_c.addChild(loader);
			}
			else {
				if(_c.numChildren > 0) {
//					loader = _c.getChildAt(0) as Loader;
//					try {
//						loader.close();
//					}
//					catch(err:Error) {}
//					loader.unload();
//					
//					_c.removeChild(loader);
				}
				
			}
			
			trace("Loader数：", _c.numChildren);
			
			if(_c.numChildren > 140) test222();
		}
		
		
		private function test222():void
		{
			trace("回收");
			
			while(_c.numChildren > 0) _c.removeChildAt(0);
			Common.gc();
		}
		
		
		
		override protected function startup():void
		{
			
		}
		//
	}
}