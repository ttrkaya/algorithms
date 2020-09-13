package  
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class AABB 
	{
		public var minX:Number;
		public var minY:Number;
		public var maxX:Number;
		public var maxY:Number;
		
		public var i:int;
		
		public function AABB(minX:Number=0, minY:Number=0, maxX:Number=0, maxY:Number=0) 
		{
			this.minX = minX;
			this.minY = minY;
			this.maxX = maxX;
			this.maxY = maxY;
		}
		
		public function copy(a:AABB):void
		{
			this.minX = a.minX;
			this.minY = a.minY;
			this.maxX = a.maxX;
			this.maxY = a.maxY;
		}
		
		public function hits(a:AABB):Boolean
		{
			if (minX > a.maxX) return false;
			if (minY > a.maxY) return false;
			if (maxX < a.minX) return false;
			if (maxY < a.minY) return false;
			return true;
		}
		
		public function getArea():Number
		{
			return (maxX - minX) * (maxY - minY);
		}
	}

}