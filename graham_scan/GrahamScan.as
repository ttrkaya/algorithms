package
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class GrahamScan extends Sprite
	{
		private var points:Vector.<P>;
		private static const NUM_POINTS:int = 125;
		
		private var polyView:Shape;
		
		private var isMouseDown:Boolean = false;
		private var selectedPointView:MovieClip;
		private var selectionOffset:Point = new Point();
		
		public function GrahamScan()
		{
			var i:int;
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x888888);
			bg.graphics.drawRect(-1000,-1000,3000,3000);
			bg.graphics.endFill();
			this.addChild(bg);
			
			polyView = new Shape();
			this.addChild(polyView);
			
			points = new Vector.<P>;
			for(i=0; i<NUM_POINTS; i++)
			{
				var p:P = new P();
				p.x = 50 + Math.random() * 300;
				p.y = 50 + Math.random() * 300;
				
				var view:MovieClip = new MovieClip();
				view.graphics.lineStyle(1,0x0);
				view.graphics.beginFill(0x00ff00);
				view.graphics.drawCircle(0,0,5);
				view.graphics.endFill();
				view.x = p.x;
				view.y = p.y;
				this.addChild(view);
				view.buttonMode = true;
				view.addEventListener(MouseEvent.MOUSE_DOWN, onPointMouseDown);
				p.view = view;
				view.p = p;
				
				points.push(p);
			}
			
			drawPolygon();
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
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
			selectedPointView.p.x = selectedPointView.x;
			selectedPointView.p.y = selectedPointView.y;
			
			drawPolygon();
		}
		
		private function drawPolygon():void
		{
			var i:int;
			
			var lowestPoint:P = points[0];
			for(i=1; i<NUM_POINTS; i++)
			{
				if(points[i].y > lowestPoint.y) lowestPoint = points[i];
			}
			
			for(i=0; i<NUM_POINTS; i++)
			{
				points[i].angle = Math.atan2(points[i].y - lowestPoint.y, points[i].x - lowestPoint.x);
			}
			
			var sorted:Vector.<P> = points.sort(sortHelper).slice();
			
			for(i=2; i<sorted.length; i++)
			{
				var p0:P = sorted[i];
				var p1:P = sorted[i-1];
				var p2:P = sorted[i-2];
				
				var exDirX:Number = p1.x - p2.x;
				var exDirY:Number = p1.y - p2.y;
				var newDirX:Number = p0.x - p1.x;
				var newDirY:Number = p0.y - p1.y;
				if(exDirX*newDirY - exDirY*newDirX > 0)
				{
					sorted.splice(i-1,1);
					i-=2;
					if(i<1) i=1;
				}
			}
			
			polyView.graphics.clear();
			polyView.graphics.beginFill(0x0000ff);
			polyView.graphics.moveTo(sorted[0].x, sorted[0].y);
			for(i=1; i<sorted.length; i++)
			{
				polyView.graphics.lineTo(sorted[i].x, sorted[i].y);
			}
			polyView.graphics.endFill();
		}
		
		private function sortHelper(p0:P, p1:P):Number
		{
			return p1.angle - p0.angle;
		}
	}
}