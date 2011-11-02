package reign.components
{
	import com.greensock.TweenMax;
	
	import reign.common.Common;

	/**
	 * 显示数字的文本
	 * 在值上升或下降时，闪动颜色
	 * @author LOLO
	 */
	public class NumberText extends Label
	{
		/**文本原来的颜色*/
		public var originalColor:uint;
		/**值增加时，切换的颜色*/
		public var upColor:uint;
		/**值减少时，切换的颜色*/
		public var downColor:uint;
		
		/**每次切换的间隔（秒）*/
		public var delay:Number;
		
		/**新的值*/
		private var _newValue:Number;
		
		
		public function NumberText()
		{
			super();
			
			super.text = "0";
			_originalText = "init";
			
			this.style = Common.style.getStyle("numberText");
		}
		
		override public function set style(value:Object):void
		{
			super.style = value;
			
			if(value.originalColor != null) {
				originalColor = value.originalColor;
				this.color = originalColor;
			}
			if(value.upColor != null) upColor = value.upColor;
			if(value.downColor != null) downColor = value.downColor;
			if(value.delay != null) delay = value.delay;
		}
		
		
		override public function set text(value:String):void
		{
			_newValue = Number(value);
			
			if(isNaN(_newValue))
			{
				throw new Error("NumberText的text属性，必须为数字");
				return;
			}
			
			//第一次赋值
			if(_originalText == "init")
			{
				super.text = _newValue.toString();
				return;
			}
			
			var oldValue:Number = Number(_originalText);
			
			//值有变化
			if(_newValue != oldValue)
			{
				TweenMax.killDelayedCallsTo(changeColor);
				TweenMax.delayedCall(delay, changeColor, [0, (_newValue > oldValue) ? upColor : downColor]);
			}
		}
		
		
		/**
		 * 改变文本颜色
		 * @param count 已改变次数
		 * @param color 与文本原来的颜色，进行相互切换的颜色
		 */
		private function changeColor(count:int, color:uint):void
		{
			count++;
			
			this.color = (count % 2) == 1 ? color : originalColor;
			
			if(count >= 10)
			{
				super.text = _newValue.toString();
				return;
			}
			
			TweenMax.delayedCall(delay, changeColor, [count, color]);
		}
		//
	}
}