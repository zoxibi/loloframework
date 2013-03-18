package game.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import lolo.common.Common;
	import lolo.components.ModalBackground;
	import lolo.core.Container;
	import lolo.events.LoadEvent;
	import lolo.ui.ILoadBar;

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
		/**当前关注的组*/
		private var _group:String = "public";
		
		
		public function LoadBar()
		{
			super();
			
			initUI(new XML(Common.loader.getResByConfigName("mainUIConfig").loadBar));
		}
		
		public function set isListener(value:Boolean):void
		{
			if(value) {
				Common.loader.addEventListener(LoadEvent.START, startHandler);
				Common.loader.addEventListener(LoadEvent.PROGRESS, progressHandler);
				Common.loader.addEventListener(LoadEvent.ITEM_COMPLETE, completeHandler);
				Common.loader.addEventListener(LoadEvent.ERROR, errorHandler);
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else {
				Common.loader.removeEventListener(LoadEvent.START, startHandler);
				Common.loader.removeEventListener(LoadEvent.PROGRESS, progressHandler);
				Common.loader.removeEventListener(LoadEvent.ITEM_COMPLETE, completeHandler);
				Common.loader.removeEventListener(LoadEvent.ERROR, errorHandler);
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function get isListener():Boolean
		{
			return hasEventListener(Event.ENTER_FRAME);
		}
		
		
		
		public function set text(value:String):void
		{
			view["progressText"].text = value;
		}
		
		public function get text():String { return view["progressText"].text; }
		
		
		
		public function set group(value:String):void
		{
			_group = value;
		}
		public function get group():String { return _group; }
		
		
		
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
		 * 开始加载资源
		 * @param event
		 */
		private function startHandler(event:LoadEvent):void
		{
			text = Common.language.getLanguage("010201", event.lim.name);
		}
		
		
		/**
		 * 资源加载中
		 * @param event
		 */
		private function progressHandler(event:LoadEvent):void
		{
			var info:Object = Common.loader.getGroupProgress(_group);
			_progress = info.progress * 100;
			text = Common.language.getLanguage("010202", event.lim.name, _progress, info.numCurrent, info.numTotal);
		}
		
		
		/**
		 * 资源加载完成
		 * @param event
		 */
		private function completeHandler(event:LoadEvent):void
		{
			text = Common.language.getLanguage("010203", event.lim.name);
		}
		
		/**
		 * 资源加载失败
		 * @param event
		 */
		private function errorHandler(event:LoadEvent):void
		{
			_progress = 1;
			text = Common.language.getLanguage("010204", event.lim.name);
		}
		//
	}
}