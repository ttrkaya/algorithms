package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private static const EPS:Number = 0.01;
		
		private var mousePoint:Vec2 = new Vec2();
		private var walls:Vector.<Line> = new Vector.<Line>;
		private var controlPoints:Vector.<Vec2> = new Vector.<Vec2>;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			walls.push(new Line(3, 3, 397, 3));
			walls.push(new Line(397, 3, 397, 397));
			walls.push(new Line(397, 397, 3, 397));
			walls.push(new Line(3, 397, 3, 3));
			controlPoints.push(new Vec2(3, 3));
			controlPoints.push(new Vec2(397, 3));
			controlPoints.push(new Vec2(397, 397));
			controlPoints.push(new Vec2(3, 397));
			
			walls.push(new Line(100, 10, 10, 100));
			controlPoints.push(new Vec2(100 - EPS, 10 + EPS));
			controlPoints.push(new Vec2(100 + EPS, 10 - EPS));
			controlPoints.push(new Vec2(10 + EPS, 100 - EPS));
			controlPoints.push(new Vec2(10 - EPS, 100 + EPS));
			
			walls.push(new Line(250, 250, 300, 250));
			walls.push(new Line(300, 250, 300, 300));
			walls.push(new Line(300, 300, 250, 300));
			walls.push(new Line(250, 300, 250, 250));
			controlPoints.push(new Vec2(250 + EPS, 250 + EPS));
			controlPoints.push(new Vec2(250 - EPS, 250 - EPS));
			controlPoints.push(new Vec2(300 - EPS, 250 + EPS));
			controlPoints.push(new Vec2(300 + EPS, 250 - EPS));
			controlPoints.push(new Vec2(300 - EPS, 300 - EPS));
			controlPoints.push(new Vec2(300 + EPS, 300 + EPS));
			controlPoints.push(new Vec2(250 + EPS, 300 - EPS));
			controlPoints.push(new Vec2(250 - EPS, 300 + EPS));
			
			walls.push(new Line(300, 50, 350, 150));
			walls.push(new Line(350, 150, 250, 150));
			walls.push(new Line(250, 150, 300, 50));
			controlPoints.push(new Vec2(300, 50 + EPS));
			controlPoints.push(new Vec2(300, 50 - EPS));
			controlPoints.push(new Vec2(350 + EPS, 150 + EPS));
			controlPoints.push(new Vec2(350 - EPS, 150 - EPS));
			controlPoints.push(new Vec2(250 - EPS, 150 + EPS));
			controlPoints.push(new Vec2(250 + EPS, 150 - EPS));
			
			walls.push(new Line(50, 250, 150, 350));
			controlPoints.push(new Vec2(50 + EPS, 250 + EPS));
			controlPoints.push(new Vec2(50 - EPS, 250 - EPS));
			controlPoints.push(new Vec2(150 + EPS, 350 + EPS));
			controlPoints.push(new Vec2(150 - EPS, 350 - EPS));
			walls.push(new Line(50, 350, 150, 250));
			controlPoints.push(new Vec2(50 - EPS, 350 + EPS));
			controlPoints.push(new Vec2(50 + EPS, 350 - EPS));
			controlPoints.push(new Vec2(150 - EPS, 250 + EPS));
			controlPoints.push(new Vec2(150 + EPS, 250 - EPS));
			controlPoints.push(new Vec2(100 + EPS, 300 + EPS));
			controlPoints.push(new Vec2(100 + EPS, 300 - EPS));
			controlPoints.push(new Vec2(100 - EPS, 300 - EPS));
			controlPoints.push(new Vec2(100 - EPS, 300 + EPS));
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var i:int, j:int;
			
			mousePoint.x = mouseX;
			mousePoint.y = mouseY;
			
			var seeLines:Vector.<Line> = new Vector.<Line>(controlPoints.length);
			for (i = controlPoints.length - 1; i >= 0; i-- )
			{
				var controlPoint:Vec2 = controlPoints[i];
				var newSeeLine:Line = new Line(mousePoint.x, mousePoint.y, controlPoint.x, controlPoint.y);
				newSeeLine.normalize(1000);
				seeLines[i] = newSeeLine;
			}
			
			var seePoints:Vector.<Vec2> = new Vector.<Vec2>;
			for (i = seeLines.length - 1; i >= 0; i-- )
			{
				var seePoint:Vec2 = null;
				var seeDist2:Number;
				var seeLine:Line = seeLines[i];
				for (j = walls.length - 1; j >= 0; j-- )
				{
					var wall:Line = walls[j];
					if (wall.intersects(seeLine))
					{
						var intersection:Vec2 = wall.getIntersection(seeLine);
						if (!seePoint)
						{
							seePoint = intersection;
							seeDist2 = seePoint.subs(mousePoint).l2();
						}
						else
						{
							var newDist2:Number = intersection.subs(mousePoint).l2();
							if (newDist2 < seeDist2)
							{
								seeDist2 = newDist2;
								seePoint = intersection;
							}
						}
					}
				}
				if (seePoint)
				{
					seePoints.push(seePoint);
				}
			}
			
			seePoints.sort(sf);
			
			graphics.clear();
			graphics.beginFill(0x0);
			graphics.drawRect(0, 0, 400, 400);
			graphics.endFill();
			
			graphics.beginFill(0xaaaaaa);
			graphics.moveTo(seePoints[0].x, seePoints[0].y);
			for (i = seePoints.length - 1; i >= 0; i-- )
			{
				var seen:Vec2 = seePoints[i];
				graphics.lineTo(seen.x, seen.y);
			}
			
			graphics.lineStyle(3, 0x0000ff);
			for (i = walls.length - 1; i >= 0; i-- )
			{
				var wallToDraw:Line = walls[i];
				graphics.moveTo(wallToDraw.a.x, wallToDraw.a.y);
				graphics.lineTo(wallToDraw.b.x, wallToDraw.b.y);
			}
		}
	
		private function sf(a:Vec2, b:Vec2):int
		{
			var a1:Number = Math.atan2(a.y - mousePoint.y, a.x - mousePoint.x);
			var a2:Number = Math.atan2(b.y - mousePoint.y, b.x - mousePoint.x);
			if (a1 < a2) return 1;
			if (a1 > a2) return -1;
			return 0;
		}
	}
}