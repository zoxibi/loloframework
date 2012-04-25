package game.module.testScene.view
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	
	import reign.common.Common;
	import reign.components.Button;
	import reign.core.Container;
	
	public class SoundPop extends Container
	{
		public var effect1Btn:Button;
		public var effect2Btn:Button;
		public var effect3Btn:Button;
		
		private var _effect:Sprite;
		private var _type:int;
		
		
		public function SoundPop()
		{
			super();
			
			_effect = new Sprite();
			this.addChild(_effect);
			
			this.graphics.clear();
			this.graphics.beginFill(0);
			this.graphics.drawRect(0, 50, 300, 100);
			this.graphics.endFill();
		}
		
		
		override public function initUI(config:XML):void
		{
			super.initUI(config);
			
			effect1Btn.addEventListener(MouseEvent.CLICK, effectBtn_clickHandler);
			effect2Btn.addEventListener(MouseEvent.CLICK, effectBtn_clickHandler);
			effect3Btn.addEventListener(MouseEvent.CLICK, effectBtn_clickHandler);
			
			effect1Btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
		
		
		private function effectBtn_clickHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case effect1Btn:
					_type = 1;
					break;
				
				case effect2Btn:
					_type = 2;
					break;
				
				case effect3Btn:
					_type = 3;
					break;
			}
		}
		
		
		
		private function enterFrameHandler(event:Event):void
		{
			_effect.graphics.clear();
			
			var bytes:ByteArray = new ByteArray();
			var i:int;
			var n:Number;
			var offsetsX:int = 25;
			var offsetsY:int = 100;
			switch(_type)
			{
				case 1:
					SoundMixer.computeSpectrum(bytes, true, 0);
					for(i = 0; i < 64; i++)
					{
						bytes.position = i * 4 * 4;
						n = bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						
						bytes.position = 256 * 4 + i * 4 * 4;
						n += bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						
						n = n / 8 * 30;
						
						_effect.graphics.lineStyle(3, 0xFF0000, 1, true, "noSacle", "none");
						_effect.graphics.moveTo(offsetsX + i * 4, offsetsY);
						_effect.graphics.lineTo(offsetsX + i * 4, offsetsY - n);
						
						_effect.graphics.lineStyle(3, 0xFF0000, 0.25, true, "noSacle", "none");
						_effect.graphics.moveTo(offsetsX + i * 4, offsetsY);
						_effect.graphics.lineTo(offsetsX + i * 4, offsetsY + n);
					}
					break;
				
				
				case 2:
					SoundMixer.computeSpectrum(bytes);
					_effect.graphics.lineStyle(1, 0xFF0000, 1, true, "noSacle", "none");
					
					for(i = 0; i < 128; i++)
					{
						bytes.position = i * 4 * 4;
						n = bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						n += bytes.readFloat();
						
						n = n / 4 * 40;
						_effect.graphics.moveTo(offsetsX + i * 2, offsetsY + n);
						_effect.graphics.lineTo(offsetsX + i * 2, offsetsY - n);
					}
					
					break;
				
				
				case 3:
					SoundMixer.computeSpectrum(bytes);
					_effect.graphics.moveTo(offsetsX, offsetsY);
					_effect.graphics.lineStyle(1, 0xFF0000, 1, true, "noSacle", "none");
					for(i = 0; i < 256; i++) {
						bytes.position = i * 4 * 2;
						n = bytes.readFloat();
						n += bytes.readFloat();
						n = n / 2 * 40;
						_effect.graphics.lineTo(offsetsX + i, offsetsY - n);
					}
					break;
			}
		}
		
		
		
		
		
		override protected function startup():void
		{
			Common.sound.play("background", "3");
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		override protected function reset():void
		{
			_effect.graphics.clear();
			Common.sound.stop("background", "3");
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		//
	}
}