package reign.utils
{
	/**
	 * 随机数工具
	 * @author LOLO
	 */
	public class RandomUtil
	{
		
		/**
		 * 获取一个不重复的随机数
		 * @return 
		 */
		public static function getNotRepeat():Number
		{
			return Number(String(new Date().time).slice(5)) + Math.random();
		}
		
		
		/**
		 * 获取介于min与max之间的随机数
		 * @param min 最小值
		 * @param max 最大值
		 * @return 
		 */
		public static function getBetween(min:Number, max:Number):Number
		{
			return 0;
		}
		//
	}
}