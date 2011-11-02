package reign.common
{
	import flash.media.SoundChannel;

	/**
	 * 音频管理
	 * @author LOLO
	 */
	public interface ISoundManager
	{
		/**
		 * 播放音频，并返回音频的SoundChannel对象
		 * @param url 音频的网络地址
		 * @param parallel 是否可以与其他音频（不能并行播放的音频）并行播放。
		 * @param replay 如果音频正在播放，是否重新开始播放
		 * @return 
		 */
		function play(url:String, parallel:Boolean=false, replay:Boolean=true):SoundChannel;
	}
}