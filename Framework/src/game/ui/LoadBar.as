package game.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import reign.common.Common;
	import reign.components.ModalBackground;
	import reign.core.Container;
	import reign.events.LoadResourceEvent;
	import reign.ui.ILoadBar;

	/**
	 * 加载条
	 * @author LOLO
	 */
	public class LoadBar extends Container implements ILoadBar
	{
		/**模态背景*/
		public var modalBG:ModalBackground;
		/**显示对象*/
		public var view:DisplayObject;
		
		/**当前进度*/
		private var _progress:uint;
		
		
		public function LoadBar()
		{
			super();
			
			initUI(new XML(Common.loader.getXML(Common.language.getLanguage("020103")).loadBar));
		}
		
		public function set addListenerToRes(value:Boolean):void
		{
			if(value) {
				Common.loader.addEventListener(LoadResourceEvent.COMPLETE,	completeHandler);
				Common.loader.addEventListener(LoadResourceEvent.PROGRESS,	progressHandler);
				Common.loader.addEventListener(LoadResourceEvent.ERROR,		errorHandler);
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else {
				Common.loader.removeEventListener(LoadResourceEvent.COMPLETE,	completeHandler);
				Common.loader.removeEventListener(LoadResourceEvent.PROGRESS,	progressHandler);
				Common.loader.removeEventListener(LoadResourceEvent.ERROR,		errorHandler);
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		/**
		 * 设置显示文本
		 * @param value
		 */
		public function set text(value:String):void
		{
			view["progressText"].text = value;
		}
		
		
		/**
		 * 帧刷新
		 * @param event
		 */
		private function enterFrameHandler(event:Event):void
		{
			if(_progress > view["bar"].currentFrame) {
				view["bar"].nextFrame();
			}
			else {
				view["bar"].gotoAndPlay(_progress);
			}
		}
		
		
		/**
		 * 资源加载中
		 * @param event
		 */
		private function progressHandler(event:LoadResourceEvent):void
		{
			_progress = event.progress * 100;
			text = Common.language.getLanguage("010201", event.name, _progress, event.speed, event.numLoaded, event.numTotal);
		}
		
		
		/**
		 * 资源加载完成
		 * @param event
		 */
		private function completeHandler(event:LoadResourceEvent):void
		{
			text = Common.language.getLanguage("010202", event.name);
		}
		
		/**
		 * 资源加载失败
		 * @param event
		 */
		private function errorHandler(event:LoadResourceEvent):void
		{
			_progress = 1;
			text = Common.language.getLanguage("010203", event.name);
		}
		//
	}
}