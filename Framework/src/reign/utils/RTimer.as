package reign.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * 计时器
	 * @author LOLO
	 */
	public class RTimer
	{
		/**定时器列表（以delay为key）*/
		private static var _list:Dictionary = new Dictionary();
		
		/**在列表中的key（_list[delay].list[_key]=RTimer）*/
		private var _key:uint;
		/**计时器间隔*/
		private var _delay:uint;
		
		/**计时器当前已运行次数*/
		public var currentCount:uint;
		/**计时器的总运行次数，默认值0，表示无限运行*/
		public var repeatCount:uint;
		/**计时器是否正在运行中*/
		public var running:Boolean;
		
		/**每次达到间隔时的回调*/
		public var timerHander:Function;
		/**计时器达到总运行次数时的回调*/
		public var timerCompleteHandler:Function;
		
		
		
		/**
		 * 通过“计时器间隔”，获取实例
		 * @param delay 计时器间隔
		 * @param timerHander 每次达到间隔时的回调
		 * @param repeatCount 计时器的总运行次数，默认值0，表示无限运行
		 * @param timerCompleteHandler 计时器达到总运行次数时的回调
		 * @return 
		 */
		public static function getInstance(delay:uint, timerHander:Function=null, repeatCount:uint=0, timerCompleteHandler:Function=null):RTimer
		{
			createTimer(delay);
			
			var key:uint = ++_list[delay].index;
			var rTimer:RTimer = new RTimer(new Enforcer(), _list[delay].index, delay, timerHander, repeatCount, timerCompleteHandler);
			_list[delay].list[key] = rTimer;
			return rTimer;
		}
		
		
		/**
		 * 当没有该“计时器间隔”的计时器时，创建计时器
		 * @param delay
		 */
		private static function createTimer(delay:uint):void
		{
			if(_list[delay] == null)
			{
				_list[delay] = { index:0, list:new Dictionary(), timer:new Timer(delay) };
				_list[delay].timer.addEventListener(TimerEvent.TIMER, timerHandler);
			}
		}
		
		
		/**
		 * 通过delay与key，获取已经存在的计时器实例
		 * @param delay 计时器间隔
		 * @param key 
		 */
		public static function getInstanceByKey(delay:uint, key:uint):RTimer
		{
			if(_list[delay] == null) return null;
			return _list[delay].list[key];
		}
		
		
		
		/**
		 * 计时器每次达到间隔
		 * @param event
		 */
		private static function timerHandler(event:TimerEvent):void
		{
			var timer:Timer = event.target as Timer;
			var item:Object = _list[timer.delay];
			
			var running:Boolean;//是否还有计时器在运行状态
			for(var key:* in item.list)
			{
				var rTimer:RTimer = item.list[key];
				if(!rTimer.running) continue;
				
				//计时器是运行状态，进行到达间隔回调
				if(rTimer.timerHander != null) rTimer.timerHander();
				
				rTimer.currentCount++;
				//计时器已到达允许运行的最大次数
				if(rTimer.repeatCount != 0 && rTimer.currentCount >= rTimer.repeatCount) {
					rTimer.running = false;
					if(rTimer.timerCompleteHandler != null) rTimer.timerCompleteHandler();
				}
				else {
					running = true;
				}
			}
			
			//该delay，已经没有计时器在运行了
			if(!running) timer.reset();
		}
		
		
		
		public function RTimer(enforcer:Enforcer, key:uint, delay:uint, timerHander:Function, repeatCount:uint, timerCompleteHandler:Function)
		{
			if(!enforcer) {
				throw new Error("请通过RTimer.getInstance获取实例");
				return;
			}
			
			_key = key;
			_delay = delay;
			
			this.repeatCount = repeatCount;
			this.timerHander = timerHander;
			this.timerCompleteHandler = timerCompleteHandler;
		}
		
		
		
		/**
		 * 在列表中的key（_list[delay].list[_key]=RTimer）
		 */
		public function get key():uint { return _key; }
		
		
		/**
		 * 计时器间隔
		 */
		public function set delay(value:uint):void
		{
			if(_delay == value) return;
			clear();
			
			_delay = value;
			createTimer(_delay);
			
			_key = ++_list[_delay].index;
			_list[_delay].list[_key] = this;
			
			if(running) start();
		}
		public function get delay():uint { return _delay; }
		
		
		
		
		/**
		 * 开始计时器
		 */
		public function start():void
		{
			running = true;
			//没达到设置的运行最大次数
			if(repeatCount == 0 || currentCount < repeatCount)
			{
				_list[_delay].timer.start();
			}
		}
		
		
		/**
		 * 如果计时器正在运行，则停止计时器
		 */
		public function stop():void
		{
			running = false;
		}
		
		/**
		 * 如果计时器正在运行，则停止计时器，并将currentCount设为0
		 */
		public function reset():void
		{
			currentCount = 0;
			stop();
		}
		
		
		/**
		 * 从列表中清除该定时器，如果计时器正在运行，则自动停止
		 */
		public function clear():void
		{
			delete _list[_delay].list[_key];
		}
		//
	}
}


class Enforcer {}