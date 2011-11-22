package reign.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import reign.common.Common;
	import reign.data.IHashMap;
	import reign.events.components.ItemEvent;
	import reign.utils.AutoUtil;
	
	/**
	 * ComboBox组件，包含如下元素
	 * 	-输入文本（可编辑状态下显示）
	 * 	-显示文本（不可编辑状态下显示）
	 * 	-下拉按钮
	 * 	-输入文本、显示文本与下拉按钮的背景（9切片，可伸缩）
	 * 	-下拉列表（单列）
	 * 	-下拉列表的背景（9切片，可伸缩）
	 * 	-下拉列表组件对应的垂直滚动条（会自动调整尺寸）
	 * @author LOLO
	 */
	public class ComboBox extends Sprite
	{
		/**输入文本（可编辑状态下显示）*/
		public var inputText:InputText;
		/**显示文本（不可编辑状态下显示）*/
		public var labelText:Label;
		/**下拉按钮*/
		public var arrowBtn:BaseButton;
		/**输入文本、显示文本与下拉按钮的背景（9切片，可伸缩）*/
		public var textAndBtnBG:DisplayObject;
		/**下拉列表（单列）*/
		public var list:List;
		/**下拉列表的背景（9切片，可伸缩）*/
		public var listBG:DisplayObject;
		/**下拉列表组件对应的垂直滚动条（会自动调整尺寸）*/
		public var listVSB:ScrollBar;
		
		
		/**下拉列表item被选中时，在ItemRenderer中获取标签字符串的字段*/
		public var labelField:String = "label";
		/**列表的背景大于列表的高度*/
		public var listBGPaddingHeight:int;
		
		
		/**是否可以编辑*/
		private var _editable:Boolean;
		/**列表中可见行数的最大值。如果超出该值，将会自动显示滚动条。默认值：0，表示无限长*/
		private var _rowCount:int = 0;
		/**上次选中item的key*/
		private var _lastKey:String;
		/**在点击下拉按钮时，是否需要打开下拉列表*/
		private var _needOpen:Boolean = true;
		
		
		public function ComboBox()
		{
			super();
		}
		
		
		public function initUI(config:XML):void
		{
			AutoUtil.autoUI(this, config);
			
			editable = true;//默认可以编辑
			list.isDefaultSelect = false;//默认不选
			close();//默认关闭下拉列表
			
			inputText.addEventListener(FocusEvent.FOCUS_IN, inputText_focusHandler);
			inputText.addEventListener(FocusEvent.FOCUS_OUT, inputText_focusHandler);
			inputText.addEventListener(Event.CHANGE, inputText_changeHandler);
			list.addEventListener(ItemEvent.ITEM_MOUSE_DOWN, list_itemMouseDownHandler);
			if(arrowBtn != null) arrowBtn.addEventListener(MouseEvent.CLICK, arrowBtn_clickHandler);
		}
		
		
		/**
		 * 输入文本获得，失去焦点时
		 * @param event
		 */
		private function inputText_focusHandler(event:FocusEvent):void
		{
			event.type == FocusEvent.FOCUS_IN
				? Common.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler)
				: Common.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
		}
		
		/**
		 * 在舞台上按键
		 * @param event
		 */
		private function stage_keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case 12://回车
					close();
					break;
				
				case 38://上箭头
					selectItemByIndex(list.selectedItem ? list.selectedItem.index - 1 : 0);
					break;
				
				case 38://上箭头
					selectItemByIndex(list.selectedItem ? list.selectedItem.index + 1 : 0);
					break;
			}
		}
		
		
		/**
		 * 下拉列表，鼠标按下item
		 * @param event
		 */
		private function list_itemMouseDownHandler(event:ItemEvent):void
		{
			if(event.item != null) label = event.item[labelField];
		}
		
		/**
		 * 输入文本，内容有改变
		 * @param event
		 */
		private function inputText_changeHandler(event:Event):void
		{
			label = inputText.text;
			open();
		}
		
		
		/**
		 * 点击下拉按钮
		 * @param event
		 */
		private function arrowBtn_clickHandler(event:MouseEvent):void
		{
			_needOpen ? open() : _needOpen = true;
		}
		
		
		/**
		 * 鼠标在舞台上按下
		 * @param event
		 */
		private function stage_mouseDownHandler(event:MouseEvent):void
		{
			close();
			_needOpen = event.target != arrowBtn;
		}
		
		
		/**
		 * 鼠标在滚动条上按下
		 * @param event
		 */
		private function listVSB_mouseDownHandler(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		
		
		
		/**
		 * 打开下拉列表
		 */
		public function open():void
		{
			Common.stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			Common.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			listVSB.addEventListener(MouseEvent.MOUSE_DOWN, listVSB_mouseDownHandler);
			openOrCloseList(true);
		}
		
		/**
		 * 关闭下拉列表
		 */
		public function close():void
		{
			Common.stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
			Common.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			listVSB.removeEventListener(MouseEvent.MOUSE_DOWN, listVSB_mouseDownHandler);
			openOrCloseList(false);
		}
		
		
		
		/**
		 * 打开或关闭下拉列表
		 * @param isOpen
		 */
		public function openOrCloseList(isOpen:Boolean):void
		{
			list.visible = isOpen;
			if(listBG != null) listBG.visible = isOpen;
			if(listVSB != null) {
				listVSB.visible = isOpen;
				if(isOpen && listVSB.autoDisplay) list.visible = listVSB.isShow;
			}
		}
		
		
		
		
		/**
		 * 通过key选中item
		 * @param key
		 */
		public function selectItemByKey(key:String):void
		{
			var data:IHashMap = list.data;
			if(data == null) return;
			
			if(key.length > 0 && key != _lastKey)
			{
				var i:int;
				var n:int;
				var keys:Array;
				for(i = 0; i < data.length; i++)
				{
					keys = data.getKeysByIndex(i);
					if(keys != null) {
						for(n = 0; n < keys.length; n++)
						{
							if(String(keys[n]).slice(0, key.length) == key)
							{
								_lastKey = key;
								label = keys[n];
								inputText.setSelection(key.length, inputText.text.length);
								list.selectItemByDataIndex(i);
								return;
							}
						}
					}
				}
			}
			list.selectedItem = null;
			_lastKey = "";
		}
		
		
		/**
		 * 通过index选中item
		 * @param index
		 */
		public function selectItemByIndex(index:int):void
		{
			list.selectItemByDataIndex(index);
			label = list.selectedItem[labelField];
		}
		
		
		
		
		/**
		 * 设置当前文本的内容
		 */
		public function set label(value:String):void
		{
			inputText.text = labelText.text = value;
			selectItemByKey(inputText.text);
		}
		public function get label():String { return inputText.text; }
		
		
		/**
		 * 是否可以编辑
		 */
		public function set editable(value:Boolean):void
		{
			_editable = value;
			inputText.visible = value;
			labelText.visible = !value;
		}
		public function get editable():Boolean { return _editable; }
		//
	}
}