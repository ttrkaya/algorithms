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
		private const DA:Number = 0.01; //change in acceleration
		private const T:Number = 15;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			trace("exact: " + exact(T));
			trace("euler: (dt = 1.000)" + euler(T, 1));
			trace("euler: (dt = 0.100)" + euler(T, 0.1));
			trace("euler: (dt = 0.010)" + euler(T, 0.01));
			trace("euler: (dt = 0.001)" + euler(T, 0.001));
			trace("rk4: (dt = 1.000)" + rungeKutta(T, 1));
			trace("rk4: (dt = 0.100)" + rungeKutta(T, 0.1));
			trace("rk4: (dt = 0.010)" + rungeKutta(T, 0.01));
			trace("rk4: (dt = 0.001)" + rungeKutta(T, 0.001));
		}
		
		private function exact(t:Number):Number
		{
			return DA * t * t * t / 6;
		}
		
		private function euler(t:Number, dt:Number):Number
		{
			var pos:Number = 0;
			var vel:Number = 0;
			var acc:Number = 0;
			for (var tt:Number = 0; tt < t; tt += dt )
			{
				acc += DA * dt;
				vel += acc * dt;
				pos += vel * dt;
			}
			return pos;
		}
		
		private function rungeKutta(t:Number, dt:Number):Number
		{
			var pos:Number = 0;
			var vel:Number = 0;
			var dtd2:Number = dt / 2;
			for (var tt:Number = 0; tt < t; tt += dt )
			{
				var a1: Number = getAcceleration(pos, tt);
				var v1:Number = vel;
				var a2:Number = getAcceleration(pos + v1 * dtd2, tt + dtd2);
				var v2:Number = vel + a2 * dtd2;
				var a3:Number = getAcceleration(pos + v2 * dtd2, tt + dtd2);
				var v3:Number = vel + a3 * (dtd2);
				var a4:Number = getAcceleration(pos + v3 * dt, tt + dt);
				var v4:Number = vel + a4 * dt;
				
				vel += (dt / 6) * (a1 + 2 * (a2 + a3) + a4);
				pos += (dt / 6) * (v1 + 2 * (v2 + v3) + v4);
			}
			return pos;
		}
		
		private function getAcceleration(pos:Number, time:Number):Number
		{
			//our simulation is simplified, 
			//but could have been complex such as spring simulation 
			//where we would need to use position
			return DA * time;
		}
	}
	
}