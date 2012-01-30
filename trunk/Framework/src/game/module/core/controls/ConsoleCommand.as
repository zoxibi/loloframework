package game.module.core.controls
{
	import game.module.core.events.ConsoleEvent;
	
	import reign.mvc.command.ICommand;
	import reign.mvc.control.MvcEvent;
	import reign.ui.Console;
	import reign.ui.Stats;
	
	/**
	 * 处理控制台推送过来的数据
	 * @author LOLO
	 */
	public class ConsoleCommand implements ICommand
	{
		/**控制台推送过来的内容*/
		private var _content:String;
		
		
		public function execute(event:MvcEvent):void
		{
			_content = (event as ConsoleEvent).data;
			
			//发送GM指令
			if(_content.charAt(0) == "#")
			{
				return;
			}
			
			
			//前端命令
			var arr:Array = _content.split(" ");
			var args:Array = [];
			var i:int;
			var len:int = arr.length;
			for(i = 0; i < len; i++) if(arr[i] != "") args.push(arr[i]);
			
			switch(args[0])
			{
				case "统计":
					Stats.getInstance().isShow ? Stats.getInstance().hide() : Stats.getInstance().show();
					break;
				
				case "战报":
					break;
			}
		}
		
		
		
		/**
		 * 发送GM命令的结果
		 * @param success
		 * @param data
		 */
		private function sendGmCmdResult(success:Boolean, data:Object):void
		{
			var state:String = success ? "发送成功！" : "发送失败！"
			Console.trace("GM指令:“" + _content + "”  " + state);
		}
		//
	}
}