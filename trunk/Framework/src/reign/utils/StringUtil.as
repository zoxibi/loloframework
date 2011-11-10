package reign.utils
{
	/**
	 * 字符串工具
	 * @author LOLO
	 */
	public class StringUtil
	{
		
		/**
		 * 将指定字符串内的 "{n}" 标记替换成传入的参数
		 * @param str 要替换的字符串
		 * @param rest 参数列表
		 * @return 
		 */
		public static function substitute(str:String, ...rest):String
		{
			if(str == null) return "";
			
			var args:Array;
			if(rest.length == 1 && rest[0] is Array) {
				args = rest[0];
			}else {
				args = rest;
			}
			
			for(var i:int = 0; i < args.length; i++)
			{
				str = str.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			return str;
		}
		
		
		
		/**
		 * 当number小于length指定的长度时，在number前面加上前导零
		 * @param number
		 * @param length
		 * @return 
		 */
		public static function leadingZero(number:int, length:int=2):String
		{
			var str:String = number.toString();
			while(str.length < length) str = "0" + str;
			return str;
		}
		
		
		
		/**
		 * 将目标字符串组合成html文本标签包含的字符串
		 * @param str 要组合的字符串
		 * @param color 颜色
		 * @param size 文本尺寸
		 * @return 
		 */		
		public static function toHtmlFont(str:String, color:String="", size:uint=0):String
		{
			var s:String = "<font";
			
			if(color != "") {
				if(color.charAt() != "#") color = "#" + color;
				s += " color='" + color + "'";
			}
			
			if(size != 0) {
				s += " size='" + size + "'";
			}
			
			s += ">" + str + "</font>";
			return s;
		}
		//
	}
}