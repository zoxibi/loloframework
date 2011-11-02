package reign.ui
{
	/**
	 * 将与服务端通信的请求进行模态的界面
	 * @author LOLO
	 */
	public interface IRequestModal extends ICenterDisplayObject
	{
		/**
		 * 对指定的命令，开始进行通信模态
		 * @param command 请求的命令
		 */
		function startModal(command:String):void;
		
		/**
		 * 对指定的命令，结束通信模态
		 * @param command 请求的命令
		 */
		function endModal(command:String):void;
		
		
		/**
		 * 重置所有模态的通信
		 */
		function reset():void;
	}
}