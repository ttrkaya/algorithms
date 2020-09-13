package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[SWF(width="600", height="400", frameRate="30",backgroundColor="#888888")]
	public class InverseKinematics extends Sprite
	{
		private var points:Vector.<Point>;
		private var lengths:Vector.<Number>;
		private var upperAngleLimits:Vector.<Number>;
		private var lowerAngleLimits:Vector.<Number>;
		
		private static const NUM_POINTS:int = 7;
		
		public function InverseKinematics()
		{
			var i:int;
			
			points = new Vector.<Point>;
			lengths = new Vector.<Number>;
			upperAngleLimits = new Vector.<Number>;
			lowerAngleLimits = new Vector.<Number>;
			points.push(new Point(300,200));
			for(i=1; i<NUM_POINTS; i++)
			{
				var length:Number = 10 + 40*Math.random();
				lengths.push(length);
				points.push(new Point(points[i-1].x+length,200));
				
				upperAngleLimits.push(Math.PI*1);
				lowerAngleLimits.push(-Math.PI*1);
			}
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			var plusButton:Sprite = new Sprite();
			plusButton.graphics.beginFill(0x00ff00);
			plusButton.graphics.drawRoundRect(0,0,50,50,10,10);
			plusButton.graphics.endFill();
			plusButton.x = 545;
			plusButton.y = 2;
			plusButton.buttonMode = true;
			this.addChild(plusButton);
			plusButton.addEventListener(MouseEvent.MOUSE_DOWN, onPlusClicked);
			
			var minusButton:Sprite = new Sprite();
			minusButton.graphics.beginFill(0xff0000);
			minusButton.graphics.drawRoundRect(0,0,50,50,10,10);
			minusButton.graphics.endFill();
			minusButton.x = 545;
			minusButton.y = 55;
			minusButton.buttonMode = true;
			this.addChild(minusButton);
			minusButton.addEventListener(MouseEvent.MOUSE_DOWN, onMinusClicked);
		}
		
		private function update(e:Event):void
		{
			var i:int, dx:Number, dy:Number, dist:Number, angle:Number, oldAngle:Number;
			
			points[points.length-1].x = this.stage.mouseX;
			points[points.length-1].y = this.stage.mouseY;
			
			for(i=points.length-2; i>0; i--)
			{
				dx = points[i].x - points[i+1].x;
				dy = points[i].y - points[i+1].y;
				angle = Math.atan2(dy,dx);
				
//				if(i<points.length-2)
//				{
//					if(oldAngle - angle < lowerAngleLimits[i])
//					{
//						angle = lowerAngleLimits[i];
//					}
//					if(oldAngle - angle > upperAngleLimits[i])
//					{
//						angle = upperAngleLimits[i];
//					}
//				}
//				oldAngle = angle;
				
				points[i].x = points[i+1].x + Math.cos(angle)*lengths[i];
				points[i].y = points[i+1].y + Math.sin(angle)*lengths[i];
			}
			
			oldAngle = 0;
			for(i=1; i<points.length; i++)
			{
				dx = points[i].x - points[i-1].x;
				dy = points[i].y - points[i-1].y;
				angle = Math.atan2(dy,dx);
				
				var betweenAngle:Number = angle - oldAngle;
				while(betweenAngle > Math.PI) betweenAngle -= 2*Math.PI;
				while(betweenAngle < -Math.PI) betweenAngle += 2*Math.PI;
				
				if(betweenAngle < lowerAngleLimits[i-1])
				{
					angle = oldAngle + lowerAngleLimits[i-1];
					while(angle > Math.PI) angle -= 2*Math.PI;
					while(angle < -Math.PI) angle += 2*Math.PI;
				}
				if(betweenAngle > upperAngleLimits[i-1])
				{
					angle = oldAngle + upperAngleLimits[i-1];
					while(angle > Math.PI) angle -= 2*Math.PI;
					while(angle < -Math.PI) angle += 2*Math.PI;
				}
				oldAngle = angle;
				
				points[i].x = points[i-1].x + Math.cos(angle)*lengths[i-1];
				points[i].y = points[i-1].y + Math.sin(angle)*lengths[i-1];
			}
			
			this.graphics.clear();
			this.graphics.lineStyle(5,0x00ff00);
			this.graphics.moveTo(points[0].x,points[0].y);
			for(i=1; i<points.length; i++)
			{
				this.graphics.lineTo(points[i].x, points[i].y);
			}
			this.graphics.lineStyle();
			for(i=0; i<points.length; i++)
			{
				this.graphics.beginFill(0x00ff00);
				this.graphics.drawCircle(points[i].x,points[i].y,8);
				this.graphics.endFill();
				this.graphics.beginFill(0x0000ff);
				this.graphics.drawCircle(points[i].x,points[i].y,5);
				this.graphics.endFill();
			}
		}
		
		private function onPlusClicked(e:MouseEvent):void
		{
			var i:int;
			
			if(upperAngleLimits[0] < Math.PI)
			{
				for(i=0;i<upperAngleLimits.length;i++) upperAngleLimits[i] += Math.PI*0.1;
			}
			if(lowerAngleLimits[0] > -Math.PI)
			{
				for(i=0;i<lowerAngleLimits.length;i++) lowerAngleLimits[i] -= Math.PI*0.1;
			}
		}
		
		private function onMinusClicked(e:MouseEvent):void
		{
			var i:int;
			
			if(upperAngleLimits[0] > Math.PI*0.1)
			{
				for(i=0;i<upperAngleLimits.length;i++) upperAngleLimits[i] -= Math.PI*0.1;
			}
			if(lowerAngleLimits[0] < Math.PI*0.1)
			{
				for(i=0;i<lowerAngleLimits.length;i++) lowerAngleLimits[i] += Math.PI*0.1;
			}
		}
	}
}