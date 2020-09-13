package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private var xs:Vector.<Sprite>;
		private var spline:Sprite;
		
		private static const DT:Number = 0.01;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var i:int;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			this.graphics.beginFill(0xC0C0C0);
			this.graphics.drawRect(0, 0, 1000, 1000);
			this.graphics.endFill();
			
			xs = new Vector.<Sprite>;
			for(i=0; i<6; i++)
			{
				var x:Sprite = createX();
				x.x = 50 + i*100;
				x.y = 100 + (i%2==0 ? 200 : 0);
				this.addChild(x);
				xs.push(x);
				x.buttonMode = true;
				x.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownX);
				x.addEventListener(MouseEvent.MOUSE_UP, onMouseUpX);
			}
			
			spline = new Sprite();
			this.addChild(spline);
			spline.mouseChildren = false;
			spline.mouseEnabled = false;
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			var i:int;
			
			var points:Vector.<Point> = new Vector.<Point>;
			for(i=0; i<xs.length; i++)
			{
				points.push(new Point(xs[i].x, xs[i].y));
			}
			points.push(new Point(xs[0].x, xs[0].y));
			points.push(new Point(xs[1].x, xs[1].y));
			points.unshift(new Point(xs[xs.length-1].x, xs[xs.length-1].y));
			drawSpline(points);
		}
		
		private function onMouseDownX(e:MouseEvent):void 
		{
			var x:Sprite = e.currentTarget as Sprite;
			x.startDrag();
		}
		
		private function onMouseUpX(e:MouseEvent):void 
		{
			var x:Sprite = e.currentTarget as Sprite;
			x.stopDrag();
		}
		
		private function createX():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.lineStyle(10, 0x0000ff);
			s.graphics.moveTo(-15, -15);
			s.graphics.lineTo(15, 15);
			s.graphics.moveTo(15, -15);
			s.graphics.lineTo(-15, 15);
			
			return s;
		}
		
		private function drawSpline(points:Vector.<Point>):void
		{
			var i:int, l:int, t:Number, p:Point;
			
			spline.graphics.clear();
			spline.graphics.lineStyle(5, 0x00ff00);
			for(i=0, l=points.length-3; i<l; i++)
			{
				var p0:Point = points[i];
				var p1:Point = points[i+1];
				var p2:Point = points[i+2];
				var p3:Point = points[i+3];
				
				p = getSplineValue(p0, p1, p2, p3, 0);
				spline.graphics.moveTo(p.x, p.y);
				for(t=DT; t<=1; t+=DT)
				{
					p = getSplineValue(p0, p1, p2, p3, t);
					spline.graphics.lineTo(p.x, p.y);
				}
			}
		}
		
		private function getSplineValue(p0:Point, p1:Point, p2:Point, p3:Point, t:Number):Point
		{
			var r:Point = new Point();
			r.x = 0.5 * (2*p1.x + (-p0.x + p2.x)*t + (2*p0.x - 5*p1.x + 4*p2.x - p3.x)*t*t + (-p0.x + 3*p1.x - 3*p2.x + p3.x)*t*t*t);
			r.y = 0.5 * (2*p1.y + (-p0.y + p2.y)*t + (2*p0.y - 5*p1.y + 4*p2.y - p3.y)*t*t + (-p0.y + 3*p1.y - 3*p2.y + p3.y)*t*t*t);
			return r;
		}
	}
	
}