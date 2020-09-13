package 
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Vec2 
	{
		public var x:Number;
		public var y:Number;
		
		public function Vec2(x:Number = 0, y:Number = 0) 
		{
			this.x = x;
			this.y = y;
		}
		
		public function copy(v:Vec2):void
		{
			x = v.x;
			y = v.y;
		}
		
		public function l2():Number
		{
			return x * x + y * y;
		}
			
		public function l():Number
		{
			return Math.sqrt(l2());
		}
		
		public function normalize():void
		{
			var l:Number = l();
			x /= l;
			y /= l;
		}
		
		public function scale(s:Number):void
		{
			x *= s;
			y *= s;
		}
		
		public function dot(v:Vec2):Number
		{
			return x * v.x + y * v.y;
		}
		
		public function cross(v:Vec2):Number
		{
			return x * v.y - y * v.x;
		}
		
		public function subs(v:Vec2):Vec2
		{
			return new Vec2(x - v.x, y - v.y);
		}
		
	}

}