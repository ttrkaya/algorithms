package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class SAT extends Sprite
	{
		private const NUM_POINTS_0:int = 4;
		private var inputPoints0:Vector.<P>;
		
		private const NUM_POINTS_1:int = 4;
		private var inputPoints1:Vector.<P>;
		
		private var polyView:Shape;
		
		private var isMouseDown:Boolean = false;
		private var selectedPointView:MovieClip;
		private var selectionOffset:Point = new Point();
		
		private const COLOR0:uint = 0x00ff00;
		private const COLOR1:uint = 0x0000ff;
		
		public function SAT()
		{
			var i:int;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x888888);
			bg.graphics.drawRect(-1000,-1000,3000,3000);
			bg.graphics.endFill();
			this.addChild(bg);
			
			polyView = new Shape();
			this.addChild(polyView);
			
			inputPoints0 = new Vector.<P>;
			for(i=0; i<NUM_POINTS_0; i++)
			{
				inputPoints0.push(createP(-150+100*Math.random(), -150+100*Math.random(), COLOR0, true));
			}
			inputPoints1 = new Vector.<P>;
			for(i=0; i<NUM_POINTS_1; i++)
			{
				inputPoints1.push(createP(-50+100*Math.random(), -150+100*Math.random(), COLOR1, true));
			}
			
			draw();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function createP(x:Number, y:Number, color:uint, isListened:Boolean):P
		{
			var p:P = new P();
			p.x = x;
			p.y = y;
			
			var view:MovieClip = new MovieClip();
			view.graphics.lineStyle(1,0x0);
			view.graphics.beginFill(color);
			view.graphics.drawCircle(0,0,5);
			view.graphics.endFill();
			view.x = p.x + 200;
			view.y = p.y + 200;
			this.addChild(view);
			if(isListened)
			{
				view.buttonMode = true;
				view.addEventListener(MouseEvent.MOUSE_DOWN, onPointMouseDown);
			}
			else
			{
				view.mouseChildren = false;
				view.mouseEnabled = false;
			}
			p.view = view;
			view.p = p;
			
			return p;
		}
		
		private function onPointMouseDown(e:MouseEvent):void
		{
			isMouseDown = true;
			selectedPointView = e.currentTarget as MovieClip;
			selectionOffset.x = selectedPointView.x - stage.mouseX;
			selectionOffset.y = selectedPointView.y - stage.mouseY;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			isMouseDown = false;
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if(!isMouseDown) return;
			
			selectedPointView.x = stage.mouseX + selectionOffset.x;
			selectedPointView.y = stage.mouseY + selectionOffset.y;
			selectedPointView.p.x = selectedPointView.x - 200;
			selectedPointView.p.y = selectedPointView.y - 200;
			
			draw();
		}
		
		private function draw():void
		{
			var i:int;
			
			polyView.graphics.clear();
			
			var inputConvex0:Vector.<P> = getConvexHull(inputPoints0);
			var inputConvex1:Vector.<P> = getConvexHull(inputPoints1);
			
			var dirs:Vector.<Point> = new Vector.<Point>;
			for(i=0; i<inputConvex0.length; i++)
			{
				var c00:P = inputConvex0[i];
				var c01:P = inputConvex0[(i+1) % inputConvex0.length];
				var dir0:Point = new Point(c01.y-c00.y, -(c01.x-c00.x) );
				dir0.normalize(1);
				dirs.push(dir0);
			}
			for(i=0; i<inputConvex1.length; i++)
			{
				var c10:P = inputConvex1[i];
				var c11:P = inputConvex1[(i+1) % inputConvex1.length];
				var dir1:Point = new Point(c11.y-c10.y, -(c11.x-c10.x) );
				dir1.normalize(1);
				dirs.push(dir1);
			}
			
			var limits0:Vector.<Point> = new Vector.<Point>;
			var limits1:Vector.<Point> = new Vector.<Point>;
			for(i=0; i<dirs.length; i++)
			{
				limits0.push(getRangesInDir(inputConvex0, dirs[i]));
				limits1.push(getRangesInDir(inputConvex1, dirs[i]));
			}
			
			var collidingDirIndex:int = -1;
			var minPenetration:Number = Number.MAX_VALUE;
			for(i=0; i<dirs.length; i++)
			{
				if(limits0[i].y < limits1[i].x || limits1[i].y < limits0[i].x)
				{
					collidingDirIndex = -1;
					break;
				}
				
				var penetration:Number = limits0[i].x < limits1[i].x ? limits0[i].y - limits1[i].x : limits1[i].y - limits0[i].x;
				if(penetration < minPenetration)
				{
					minPenetration = penetration;
					collidingDirIndex = i;
				}
			}
			
			for(i=0; i<dirs.length; i++)
			{
				polyView.graphics.lineStyle(1, i == collidingDirIndex ? 0xff0000 : 0xffffff);
				polyView.graphics.moveTo(200 - dirs[i].x * 1000, 200 - dirs[i].y * 1000);
				polyView.graphics.lineTo(200 + dirs[i].x * 1000, 200 + dirs[i].y * 1000);
				
				const R:Number = 3;
				polyView.graphics.lineStyle(1, COLOR0);
				polyView.graphics.drawCircle(200 + dirs[i].x * limits0[i].x, 200 + dirs[i].y * limits0[i].x, R);
				polyView.graphics.drawCircle(200 + dirs[i].x * limits0[i].y, 200 + dirs[i].y * limits0[i].y, R);
				
				polyView.graphics.lineStyle(1, COLOR1);
				polyView.graphics.drawCircle(200 + dirs[i].x * limits1[i].x, 200 + dirs[i].y * limits1[i].x, R);
				polyView.graphics.drawCircle(200 + dirs[i].x * limits1[i].y, 200 + dirs[i].y * limits1[i].y, R);
			}
			
			polyView.graphics.lineStyle(1, COLOR0);
			polyView.graphics.beginFill(COLOR0, 0.5);
			polyView.graphics.moveTo(inputConvex0[0].x + 200, inputConvex0[0].y + 200);
			for(i=1; i<inputConvex0.length; i++)
			{
				polyView.graphics.lineTo(inputConvex0[i].x + 200, inputConvex0[i].y + 200);
			}
			polyView.graphics.endFill();
			
			polyView.graphics.lineStyle(1, COLOR1);
			polyView.graphics.beginFill(COLOR1, 0.5);
			polyView.graphics.moveTo(inputConvex1[0].x + 200, inputConvex1[0].y + 200);
			for(i=1; i<inputConvex1.length; i++)
			{
				polyView.graphics.lineTo(inputConvex1[i].x + 200, inputConvex1[i].y + 200);
			}
			polyView.graphics.endFill();
		}
		
		private function getConvexHull(points:Vector.<P>):Vector.<P>
		{
			var i:int;
			var l:int = points.length;
			
			var lowestPoint:P = points[0];
			for(i=1; i<l; i++)
			{
				if(points[i].y > lowestPoint.y) lowestPoint = points[i];
			}
			
			for(i=0; i<l; i++)
			{
				points[i].angle = Math.atan2(points[i].y - lowestPoint.y, points[i].x - lowestPoint.x);
			}
			
			var convex:Vector.<P> = points.sort(sortHelper).slice();
			
			for(i=2; i<convex.length; i++)
			{
				var p0:P = convex[i];
				var p1:P = convex[i-1];
				var p2:P = convex[i-2];
				
				var exDirX:Number = p1.x - p2.x;
				var exDirY:Number = p1.y - p2.y;
				var newDirX:Number = p0.x - p1.x;
				var newDirY:Number = p0.y - p1.y;
				if(exDirX*newDirY - exDirY*newDirX > 0)
				{
					convex.splice(i-1,1);
					i-=2;
					if(i<1) i=1;
				}
			}
			
			return convex;
		}
		private function sortHelper(p0:P, p1:P):Number
		{
			return p1.angle - p0.angle;
		}
		
		private function getRangesInDir(pol:Vector.<P>, dir:Point):Point
		{
			var i:int;
			
			var range:Point = new Point();
			range.x = Number.MAX_VALUE;
			range.y = -Number.MAX_VALUE;
			for(i=0; i<pol.length; i++)
			{
				var vertex:P = pol[i];
				var proj:Number = vertex.x * dir.x + vertex.y * dir.y;
				if(proj < range.x) range.x = proj;
				if(proj > range.y) range.y = proj;
			}
			
			return range;
		}
	}
}