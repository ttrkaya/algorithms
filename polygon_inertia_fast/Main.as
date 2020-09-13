package 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Main extends Sprite 
	{
		private static const NP:int = 5;
		private var _points:Vector.<Sprite>;
		private var _draggedPoint:Sprite;
		private var _bg:Shape;
		private var _tf:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			var i:int, l:int;
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_bg = new Shape();
			stage.addChild(_bg);
			
			_points = new Vector.<Sprite>(NP);
			for (i = 0; i < NP; i++)
			{
				var s:Sprite = new Sprite();
				s.graphics.beginFill(0x0000ff);
				s.graphics.drawCircle(0, 0, 10);
				s.graphics.endFill();
				s.buttonMode = true;
				s.x = 400 * Math.random();
				s.y = 400 * Math.random();
				stage.addChild(s);
				s.addEventListener(MouseEvent.MOUSE_DOWN, onPointDown);
				_points[i] = s;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			
			_tf = new TextField();
			_tf.width = 400;
			_tf.mouseEnabled = false;
			stage.addChild(_tf);
			
			render();
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onPointDown(e:MouseEvent):void
		{
			_draggedPoint = e.target as Sprite;
		}
		
		private function onUp(e:MouseEvent):void
		{
			_draggedPoint = null;
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (_draggedPoint)
			{
				_draggedPoint.x = stage.mouseX;
				_draggedPoint.y = stage.mouseY;
				
				render();
			}
		}
		
		private function render():void
		{
			var i:int, l:int;
			
			var vertices:Vector.<RiVec> = new Vector.<RiVec>(NP);
			for (i = 0; i < NP; i++)
			{
				var s:Sprite = _points[i];
				vertices[i] = new RiVec(s.x, s.y);
			}
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x888888);
			_bg.graphics.drawRect(0,0,400,400);
			_bg.graphics.endFill();
			_bg.graphics.lineStyle(1, 0x0000ff);
			_bg.graphics.beginFill(0x00ff00);
			_bg.graphics.moveTo(vertices[0].x, vertices[0].y);
			for (i = 1; i < NP; i++) _bg.graphics.lineTo(vertices[i].x, vertices[i].y);
			_bg.graphics.endFill();
			
			var ibt:Number = getInertiaByTriangulization(vertices);
			var ibg:Number = getInertiaByGreen(vertices);
			
			_tf.text = "triangulation:\t" + Math.round(ibt) + "\n" + "green's theorem:\t" + Math.round(ibg);
		}
		
		private function getInertiaByGreen(vertices:Vector.<RiVec>):Number
		{
			var i:int, l:int, v0:RiVec, v1:RiVec;
			
			l = vertices.length;
			
			var mass:Number = 0;
			var center:RiVec = new RiVec(0, 0);
			for (i = 0; i < l; i++)
			{
				v0 = vertices[i];
				v1 = vertices[(i + 1) % l];
				
				var cross:Number = (v0.x * v1.y - v1.x * v0.y);
				mass += cross;
				center.x += (v0.x + v1.x) * cross;
				center.y += (v0.y + v1.y) * cross;
			}
			mass /= 2;
			center.scale(1 / (6 * mass));
			
			for (i = 0; i < l; i++)
			{
				vertices[i].sub(center);
			}
			
			var inertia:Number = 0;
			for (i = 0; i < l; i++)
			{
				v0 = vertices[i];
				v1 = vertices[(i + 1) % l];
				
				var ixx:Number = -(v1.x - v0.x) * (v0.y * v0.y * v0.y + v1.y * v0.y * v0.y + v1.y * v1.y * v0.y + v1.y * v1.y * v1.y);
				var iyy:Number = (v1.y - v0.y) * (v0.x * v0.x * v0.x + v1.x * v0.x * v0.x + v1.x * v1.x * v0.x + v1.x * v1.x * v1.x);
				inertia += (ixx + iyy) / 12;
			}
			
			if (inertia < 0) inertia *= -1;
			return inertia;
		}
		
		private function getInertiaByTriangulization(vertices:Vector.<RiVec>):Number
		{
			var i:int, l:int;
			
			l = vertices.length;
			var geomCenter:RiVec = RiGeomUtils.getAverage(vertices);
			//var center = getCenterOfMass();
			
			var mass:Number = 0;
			var centerOfMass:RiVec = new RiVec(0, 0);
			var triangleCenters:Vector.<RiVec> = new Vector.<RiVec>(l);
			var triangleMasses:Vector.<Number> = new Vector.<Number>(l);
			for(i=0; i<l; i++)
			{
				var area:Number = RiGeomUtils.getTriangleArea(geomCenter, vertices[i], vertices[(i+1)%l]);
				var triangleMass:Number = area;
				mass += triangleMass;
				
				var triangleCenter:RiVec = RiGeomUtils.getCenterOfTriangle(geomCenter, vertices[i], vertices[(i+1)%l]);
				centerOfMass.addScaled(triangleCenter, triangleMass);
				triangleCenters[i] = triangleCenter;
				triangleMasses[i] = triangleMass;
			}
			centerOfMass.scale(1 / mass);
			
			var inertia:Number = 0;
			for(i=0; i<l; i++)
			{
				var triangleInertia:Number = getMomentOfInertiaOfTriangle(geomCenter, vertices[i], vertices[(i+1)%l]);
				var d2:Number = triangleCenters[i].getSubbed(centerOfMass).getLengthSquared();
				inertia += triangleInertia + triangleMasses[i] * d2;
			}
			
			return inertia;
		}
		
		private function getMomentOfInertiaOfTriangle(v0:RiVec, v1:RiVec, v2:RiVec):Number
		{
			var dir:RiVec = v1.getSubbed(v0);
			var u:Number = v2.getSubbed(v0).dot(dir)/dir.getLengthSquared();
			var vh:RiVec = v0.getAddedScaled(dir, u);
			
			var a:Number = dir.getScaled(u).getLength();
			
			var h:Number = vh.getSubbed(v2).getLength();
			
			var b:Number = dir.getLength();
			
			var inertia:Number = b*b*b*h - b*b*h*a + b*h*a*a + b*h*h*h;
			inertia /= 36;
			
			return inertia;
		}
		
	}
	
}