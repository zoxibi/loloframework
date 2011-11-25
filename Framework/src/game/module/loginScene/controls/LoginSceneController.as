package game.module.loginScene.controls
{
	import game.common.ModuleName;
	import game.module.loginScene.events.LoginEvent;
	import game.module.loginScene.events.RegisterEvent;
	
	import reign.mvc.control.FrontController;
	import reign.mvc.control.MvcEventDispatcher;

	/**
	 * 【登录场景】命令管理
	 * @author LOLO
	 */
	public class LoginSceneController extends FrontController
	{
		public function LoginSceneController()
		{
			super();
			_eventDispatcher = MvcEventDispatcher.getInstance(ModuleName.SCENE_LOGIN);
			
			
			addCommand(RegisterEvent.EVENT_ID, RegisterCommand);
			addCommand(LoginEvent.EVENT_ID, LoginCommand);
		}
		//
	}
}