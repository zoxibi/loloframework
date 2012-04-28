package game.common
{
	import lolo.data.RequestModel;

	/**
	 * 与后台通信的数据模型列表
	 * @author LOLO
	 */
	public class RmList
	{
		/**注册帐号*/
		public static const USER_REGISTER:RequestModel = new RequestModel("user!register");
		/**登录游戏*/
		public static const USER_LOGION:RequestModel = new RequestModel("user!login");
		//
	}
}