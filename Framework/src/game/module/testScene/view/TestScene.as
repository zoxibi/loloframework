package game.module.testScene.view
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import game.module.testScene.model.TestSceneData;
	
	import reign.common.Common;
	import reign.components.Alert;
	import reign.components.ComboBox;
	import reign.components.List;
	import reign.components.MultiColorLabel;
	import reign.components.Page;
	import reign.components.RichText;
	import reign.components.ScrollBar;
	import reign.core.Scene;
	import reign.data.HashMap;
	import reign.effects.drag.DragDrop;
	import reign.effects.drag.DragDropEvent;
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
			
			_tuo = new DD(0xFF0000);
			_tuo.name = "拖";
			_tuo.x = 100;
			_tuo.y = 100;
			this.addChild(_tuo);
			
			_ting = new DD(0x00FF00);
			_ting.x = 160;
			_ting.y = 100;
			_ting.name = "t1";
			this.addChild(_ting);
			
			var ting2:DD = new DD(0x0000FF);
			ting2.name = "t2";
			ting2.x = 180;
			ting2.y = 100;
			this.addChild(ting2);
			
			var s111:Sprite = new Sprite();
			s111.addChild(_ting);
			
			var s222:Sprite = new Sprite();
			s222.addChild(ting2);
			
			this.addChild(s222);
			this.addChild(s111);
			
			var dd:DragDrop = new DragDrop(_tuo);
			
			dd.addEventListener(DragDropEvent.DRAG_DROP, testtest);
			dd.addEventListener(DragDropEvent.DRAG_END, testtest);
			dd.addEventListener(DragDropEvent.DRAG_MOVE, testtest);
			dd.addEventListener(DragDropEvent.DRAG_IN, testtest);
			dd.addEventListener(DragDropEvent.DRAG_OUT, testtest);
			dd.addEventListener(DragDropEvent.DRAG_START, testtest);
			
			
			var label:MultiColorLabel = new MultiColorLabel();
			label.multiColor = "TestMultiColor";
			label.x = 100;
			label.y = 200;
			label.stroke = "0x302010";
			label.labelProp = { font:"微软雅黑", size:20, bold:true };
			this.addChild(label);
			label.text = "测试单行渲染";
			
			
			label = new MultiColorLabel();
			label.multiColor = "TestMultiColor";
			label.x = 100;
			label.y = 250;
			label.stroke = "0x302010";
			label.labelProp = { width:400, font:"微软雅黑", size:20, bold:true, multiline:true };
			this.addChild(label);
			label.text = "测试多行逐行渲染，第一行\n第二行\n逐行渲染，第三行";
			
			
			label = new MultiColorLabel();
			label.multiColor = "TestMultiColor";
			label.x = 100;
			label.y = 350;
			label.stroke = "0x302010";
			label.lineFill = false;
			label.labelProp = { width:400, font:"微软雅黑", size:20, bold:true, multiline:true };
			this.addChild(label);
			label.text = "测试多行统一渲染，第一行\n第二行\n统一渲染，第三行";
		}
		
		private var _tuo:DD;
		private var _ting:DD;
		
		
		private function testtest(event:DragDropEvent):void
		{
			var str:String = event.dropTarget == null ? "不能停放" : event.dropTarget["name"];
			trace(event.type, str);
			
			if(event.type == DragDropEvent.DRAG_DROP)
			{
				var ting:DD = event.dropTarget as DD;
				var color:uint = _tuo.color;
				var text:String = _tuo.label.text;
				
				_tuo.color = event.dropTarget.dropTargetData;
				_tuo.draw();
				_tuo.label.text = ting.label.text;
				
				ting.color = color;
				ting.draw();
				ting.label.text = text;
			}
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
		
		
		
		override protected function startup():void
		{
			
		}
		//
	}
}