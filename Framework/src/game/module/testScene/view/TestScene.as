package game.module.testScene.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import game.module.testScene.model.TestSceneData;
	
	import lolo.common.Common;
	import lolo.components.Button;
	import lolo.core.Scene;
	import lolo.utils.bezier.CubicBezier;

	/**
	 * 测试场景
	 * @author LOLO
	 */
	public class TestScene extends Scene implements ITestScene
	{
		/**单例的实例*/
		public static var instance:TestScene;
		
		
		/**三角形*/
		public var triangle:Sprite;
		/**当前航线索引*/
		private var _routeIndex:uint;
		/**航线的贝塞尔曲线列表*/
		private var _bezierList:Vector.<CubicBezier>;
		/**虚线列表容器*/
		private var _dottedLineC:Sprite;
		/**总时间*/
		private var _totalTime:int;
		/**开始行驶的时间*/
		private var _startTime:int;
		/**现在所航行到的锚点索引*/
		private var _anchorIndex:uint;
		/**锚点间的航行时间（秒）*/
		private var _anchorDuration:Number;
		
		
		public var sndBtn:Button;
		
		public var soundPop:SoundPop = new SoundPop();
		
		
		private var _data:TestSceneData;
		
		
		public function TestScene()
		{
			super();
			instance = this;
			_data = TestSceneData.getInstance();
			initUI(Common.loader.getXML(Common.language.getLanguage("020201")));
			
			
			_dottedLineC = new Sprite();
			addChild(_dottedLineC);
			
			var pStart:Point = new Point(200, 200);
			var pEnd:Point = new Point(200, 200);
			var pBezierList:Array = [new Point(0, 100), new Point(150, 0), new Point(200, 100), new Point(300, 0), new Point(400, 100)];
			drawRoute(pStart, pEnd, pBezierList, 0, true);
			
			startSail(0, 0.5 * 60 * 1000/*, 15 * 1000*/);
			
			
			sndBtn.addEventListener(MouseEvent.CLICK, sndBtn_clickHandler);
		}
		
		private function sndBtn_clickHandler(event:Event):void
		{
			soundPop.showOrHide();
		}
		
		
		
		
		
		
		/**
		 * 绘制航线
		 * @param pStart
		 * @param pEnd
		 * @param pBezierList
		 * @param routeIndex
		 * @param isReset
		 */
		private function drawRoute(pStart:Point, pEnd:Point, pBezierList:Array, routeIndex:uint, isReset:Boolean=false):void
		{
			if(isReset) {
				while(_dottedLineC.numChildren > 0) _dottedLineC.removeChildAt(0);
				_bezierList = new Vector.<CubicBezier>();
			}
			
			var bezier:CubicBezier = new CubicBezier(pStart, pEnd, pBezierList);
			_bezierList[routeIndex] = bezier;
			
			for(var i:int=0; i < bezier.anchorCount; i++)
			{
				if(i == 0) continue;//起点
				
				var anchor:Object = bezier.getAnchorInfo(i);
				var frontAnchor:Object = bezier.getAnchorInfo(i - 1);
				var pt1:Point = new Point(frontAnchor.x, frontAnchor.y);
				var pt2:Point = new Point(anchor.x, anchor.y);
				if(i != bezier.anchorCount - 1) pt2 = Point.interpolate(pt1, pt2, 0.45);
				
				var line:Shape = new Shape();
				line.name = "r" + routeIndex + "l" + i;
				line.alpha = 0.2;
				line.graphics.lineStyle(3);
				line.graphics.moveTo(pt1.x, pt1.y);
				line.graphics.lineTo(pt2.x, pt2.y);
				_dottedLineC.addChild(line);
			}
		}
		
		/**
		 * 开始航行
		 * @param totalTime 总时间（毫秒）
		 * @param lastTime 已航行时间（毫秒）
		 */
		private function startSail(routeIndex:uint, totalTime:int, lastTime:int=0):void
		{
			_routeIndex = routeIndex;
			_totalTime = totalTime;
			_startTime = getTimer() - lastTime;
			
			//将之前航线的锚点全部变亮
			for(var i:int = 0; i < routeIndex; i++)
			{
				var bezier:CubicBezier = _bezierList[i];
				for(var n:int = 0; n < bezier.anchorCount; n++) {
					_dottedLineC.getChildByName("r" + i + "l" + n).alpha = 1;
				}
			}
			
			sailNextAnchor(true);
		}
		
		
		/**
		 * 航行到下个锚点
		 * @param isFirst 是否为首次航行
		 */
		private function sailNextAnchor(isFirst:Boolean=false):void
		{
			TweenMax.killTweensOf(triangle);
			var bezier:CubicBezier = _bezierList[_routeIndex];
			
			//初次航行
			if(isFirst) {
				var time:int = getTimer() - _startTime;
				var ratio:Number = time / _totalTime;
				_anchorIndex = ratio * (bezier.anchorCount - 1);
				_anchorDuration = _totalTime / (bezier.anchorCount - 1) / 1000;
				
				//将当前锚点之前的锚点全部变亮
				for(var i:int = 1; i < _anchorIndex; i++) {
					_dottedLineC.getChildByName("r" + _routeIndex + "l" + i).alpha = 1;
				}
			}
			else {
				_anchorIndex++;
			}
			
			//将当前锚点变亮
			if(_anchorIndex > 0) {
				_dottedLineC.getChildByName("r" + _routeIndex + "l" + _anchorIndex).alpha = 1;
			}
			
			//当前锚点和下个锚点
			var nowAnchor:Object = bezier.getAnchorInfo(_anchorIndex);
			var nextAnchor:Object = bezier.getAnchorInfo(_anchorIndex + 1);
			
			//已航行完毕
			if(nextAnchor == null) {
				trace("ok");
				return;
			}
			
			//航行
			var nowRotation:Number = nowAnchor.degrees + 90;
			var nextRotation:Number = nextAnchor.degrees + 90;
			
			if(nowRotation > 180) nowRotation -= 360;
			if(nextRotation > 180) nextRotation -= 360;
			
			if((nowRotation < 0) && (nextRotation > 0)) {
				nextRotation = nowRotation;
			}
			if((nextRotation < 0) && (nowRotation > 0)) {
				nowRotation = nextRotation;
			}
			
			triangle.x = nowAnchor.x;
			triangle.y = nowAnchor.y;
			triangle.rotation = nowRotation;
			TweenMax.to(triangle, _anchorDuration, {
				x:nextAnchor.x, y:nextAnchor.y, rotation:nextRotation,
				onComplete:sailNextAnchor, ease:Linear.easeNone
			});
		}
		//
	}
}