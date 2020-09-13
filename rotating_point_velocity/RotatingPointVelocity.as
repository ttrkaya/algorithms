package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class RotatingPointVelocity extends Sprite
	{
		private var halfSize:Point;
		private var center:Point;
		private var orientation:Number;
		
		private var linVel:Point;
		private var angVel:Number;
		
		private var lastUpdatedTime:Number;
		private var keys:Object = {};
		
		public function RotatingPointVelocity()
		{
			halfSize = new Point(30, 50);
			center = new Point(200, 200);
			orientation = 0;
			linVel = new Point(0, 0);
			angVel = 0;
			
			lastUpdatedTime = getNow();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var now:Number = getNow();
			var dt:Number = now - lastUpdatedTime;
			lastUpdatedTime = now;
			
			const POW_LIN:Number = 60;
			const POW_ANG:Number = 1.6;
			if(keys[Keyboard.A])
			{
				linVel.x -= POW_LIN * dt;
			}
			if(keys[Keyboard.D])
			{
				linVel.x += POW_LIN * dt;
			}
			if(keys[Keyboard.W])
			{
				linVel.y -= POW_LIN * dt;
			}
			if(keys[Keyboard.S])
			{
				linVel.y += POW_LIN * dt;
			}
			if(keys[Keyboard.E])
			{
				angVel += POW_ANG * dt;
			}
			if(keys[Keyboard.Q])
			{
				angVel -= POW_ANG * dt;
			}
			
			var drag:Number = Math.pow(0.3, dt);
			linVel.x *= drag;
			linVel.y *= drag;
			angVel *= drag;
			
			center.x += linVel.x *dt;
			center.y += linVel.y *dt;
			orientation += angVel * dt;
			
			draw();
		}
		
		private function getNow():Number { return (new Date()).time / 1000; }
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			keys[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			keys[e.keyCode] = false;
		}
		
		private function getTransformed(p:Point):Point
		{
			var cos:Number = Math.cos(orientation);
			var sin:Number = Math.sin(orientation);
			
			return new Point(p.x*cos - p.y*sin + center.x, p.y*cos + p.x*sin + center.y);
		}
		
		private function getLinearVelocityAtGlobalPoint(global:Point):Point
		{
			var relative:Point = new Point(global.x - center.x, global.y - center.y);
			var angToLinVel:Point = new Point(-angVel*relative.y, angVel*relative.x);
			return new Point(angToLinVel.x + linVel.x, angToLinVel.y + linVel.y);
		}
		
		private function draw():void
		{
			var i:int;
			
			var vertices:Vector.<Point> = new <Point>[
				getTransformed(new Point(halfSize.x, halfSize.y)),
				getTransformed(new Point(halfSize.x, -halfSize.y)),
				getTransformed(new Point(-halfSize.x, -halfSize.y)),
				getTransformed(new Point(-halfSize.x, halfSize.y))];
			
			var pointVels:Vector.<Point> = new <Point>[
				getLinearVelocityAtGlobalPoint(vertices[0]),
				getLinearVelocityAtGlobalPoint(vertices[1]),
				getLinearVelocityAtGlobalPoint(vertices[2]),
				getLinearVelocityAtGlobalPoint(vertices[3])];
			
			this.graphics.clear();
			
			this.graphics.beginFill(0x888888);
			this.graphics.drawRect(-1000, -1000, 3000, 3000);
			this.graphics.endFill();
			
			this.graphics.lineStyle(1,0);
			this.graphics.beginFill(0x00ff00);
			this.graphics.moveTo(vertices[0].x, vertices[0].y);
			this.graphics.lineTo(vertices[1].x, vertices[1].y);
			this.graphics.lineTo(vertices[2].x, vertices[2].y);
			this.graphics.lineTo(vertices[3].x, vertices[3].y);
			this.graphics.endFill();
			
			const L:Number = 0.4;
			this.graphics.lineStyle(3, 0xff0000);
			for(i=0; i<4; i++)
			{
				this.graphics.moveTo(vertices[i].x, vertices[i].y);
				this.graphics.lineTo(vertices[i].x + pointVels[i].x*L, vertices[i].y + pointVels[i].y*L);
			}
		}
	}
}