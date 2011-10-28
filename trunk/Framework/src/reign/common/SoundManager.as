package reign.common
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	/**
	 * 音频管理
	 * @author LOLO
	 */
	public class SoundManager implements ISoundManager
	{
		/**单例的实例*/
		private static var _instance:SoundManager;
		
		/**音频列表*/
		private var _soundList:Dictionary;
		/**当前正在播放的音频列表（不能并行播放的音频）*/
		private var _playingSoundList:Vector.<Object>;
		
		
		
		
		/**
		 * 获取实例
		 * @return 
		 */
		public static function getInstance():SoundManager
		{
			if(_instance == null) _instance = new SoundManager(new Enforcer());
			return _instance;
		}
		
		
		public function SoundManager(enforcer:Enforcer)
		{
			super();
			if(!enforcer) {
				throw new Error("请通过Common.sound获取实例");
				return;
			}
			
			_soundList = new Dictionary();
			_playingSoundList = new Vector.<Object>();
		}
		
		
		/**
		 * 播放音频，并返回音频的SoundChannel对象
		 * @param url 音频的网络地址
		 * @param parallel 是否可以与其他音频（不能并行播放的音频）并行播放。
		 * @param replay 如果音频正在播放，是否重新开始播放
		 * @return 
		 */
		public function play(url:String, parallel:Boolean=false, replay:Boolean=true):SoundChannel
		{
			//获取或创建音频对象
			var sound:Sound;
			if(_soundList[url]) {
				sound = _soundList[url];
			}else {
				sound = new Sound(new URLRequest(url), new SoundLoaderContext(1000, true));
				_soundList[url] = sound;
			}
			
			//该音频不能与其他音频（不能并行播放的音频）并行播放
			var sndChannel:SoundChannel;
			if(!parallel) {
				while(_playingSoundList.length > 0)
				{
					if(!_playingSoundList[0].parallel) {//也是不能并行播放的音频
						sndChannel = _playingSoundList.shift().sndChannel;
						sndChannel.stop();
						sndChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					}
				}
			}
			
			//不需要重新开始播放
			if(!replay) {
				for(var i:int = 0; i < _playingSoundList.length; i++)
				{
					if(_playingSoundList[i].url == url) return _playingSoundList[i].sndChannel;
				}
			}
			
			//重新开始播放音频
			sndChannel = sound.play();
			sndChannel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			if(!parallel) _playingSoundList.push({ url:url, sndChannel:sndChannel, parallel:parallel });
			return sndChannel;
		}
		
		
		
		/**
		 * 当前正在播放的音频已播放完成
		 * @param event
		 */
		private function soundCompleteHandler(event:Event):void
		{
			var sndChannel:SoundChannel;
			for(var i:int = 0; i < _playingSoundList.length; i++)
			{
				sndChannel = _playingSoundList[i].sndChannel;
				if(sndChannel == event.target) {
					sndChannel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
					_playingSoundList.splice(i, 1);//从正在播放的音频列表中移除
					return;
				}
			}
		}
		//
	}
}


class Enforcer {}