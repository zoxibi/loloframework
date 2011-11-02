package reign.effects
{
	import flash.filters.GlowFilter;

	/**
	 * AS的一些特效、样式
	 * @author LOLO
	 */
	public class AsEffect
	{
		
		
		/**
		 * 获取描边滤镜
		 * @param color 描边的颜色
		 * @return 
		 */
		public static function getStrokeFilter(color:uint = 0x000000):GlowFilter
		{
			return new GlowFilter(color, 1, 2, 2, 16);
		}
		//
	}
}