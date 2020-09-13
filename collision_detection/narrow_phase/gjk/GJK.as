package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class GJK extends Sprite
	{
		private var NUM_POINTS_0:int = 5;
		private var inputPoints0:Vector.<P>;
		
		private var NUM_POINTS_1:int = 4;
		private var inputPoints1:Vector.<P>;
		
		private var minkowskiDiffPoints:Vector.<P>;
		
		private var polyView:Shape;
		
		private var isMouseDown:Boolean = false;
		private var selectedPointView:MovieClip;
		private var selectionOffset:Point = new Point();
		
		private const COLOR0:uint = 0x00ff00;
		private const COLOR1:uint = 0x00fff;
		private const COLOR2:uint = 0xff9999;
		
		public function GJK()
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
			
			minkowskiDiffPoints = new Vector.<P>;
			
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
			polyView.graphics.lineStyle(1, 0xff0000);
			polyView.graphics.moveTo(200,0);
			polyView.graphics.lineTo(200,400);
			polyView.graphics.moveTo(0,200);
			polyView.graphics.lineTo(400,200);
			
			for(i=0; i<minkowskiDiffPoints.length; i++)
			{
				this.removeChild(minkowskiDiffPoints[i].view);
			}
			minkowskiDiffPoints.length = 0;
			
			var inputConvex0:Vector.<P> = getConvexHull(inputPoints0);
			var inputConvex1:Vector.<P> = getConvexHull(inputPoints1);
			minkowskiDiffPoints = getMinkowskiDiff(inputConvex0, inputConvex1);
			var minkowskiConvex:Vector.<P> = getConvexHull(minkowskiDiffPoints);
			
			var orgin:P = new P();
			orgin.x = 0;
			orgin.y = 0;
			var doInputsCollide:Boolean = isPointInsidePoly(orgin, minkowskiConvex);
			
			polyView.graphics.lineStyle(1, COLOR2);
			polyView.graphics.beginFill(doInputsCollide ? 0xff0000 : COLOR2, 0.5);
			polyView.graphics.moveTo(minkowskiConvex[0].x + 200, minkowskiConvex[0].y + 200);
			for(i=1; i<minkowskiConvex.length; i++)
			{
				polyView.graphics.lineTo(minkowskiConvex[i].x + 200, minkowskiConvex[i].y + 200);
			}
			polyView.graphics.endFill();
			
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
		
		private function getMinkowskiDiff(convex0:Vector.<P>, convex1:Vector.<P>):Vector.<P>
		{
			var i:int, j:int;
			
			var minkowskiDiff:Vector.<P> = new Vector.<P>;
			for(i=0; i<convex0.length; i++)
			{
				var convexVertex0:P = convex0[i];
				for(j=0; j<convex1.length; j++)
				{
					var convexVertex1:P = convex1[j];
					
					minkowskiDiff.push(createP(
						convexVertex1.x-convexVertex0.x, 
						convexVertex1.y-convexVertex0.y, 
						COLOR2, false));
				}
			}
			
			return minkowskiDiff;
		}
		
		public function isPointInsidePoly(o:P, poly:Vector.<P>):Boolean
		{
			var r:Boolean = false;
			for(var i:int=0; i<poly.length; i++)
			{
				var p:P = poly[i];
				var q:P = poly[(i+1)%poly.length];
				
				if ((p.y <= o.y && o.y < q.y || 
					q.y <= o.y && o.y < p.y) &&
					o.x < p.x + (q.x - p.x) * (o.y - p.y) / (q.y - p.y))
					r = !r;
			}
			return r;
		}
	}
}