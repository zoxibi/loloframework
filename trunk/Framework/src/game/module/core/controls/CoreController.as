package game.module.core.controls
{
	import game.common.ModuleName;
	import game.module.core.events.ConsoleEvent;
	
	import reign.mvc.control.FrontController;
	import reign.mvc.control.MvcEventDispatcher;

	/**
	 * 【游戏核心】命令管理
	 * @author LOLO
	 */
	public class CoreController extends FrontController
	{
		public function CoreController()
		{
			super();
			_eventDispatcher = MvcEventDispatcher.getInstance(ModuleName.CORE);
			
			
			addCommand(ConsoleEvent.EVENT_ID, ConsoleCommand);
		}
		//
	}
}