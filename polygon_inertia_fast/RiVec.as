package 
{
	public class RiVec
	{
		public var x:Number;
		public var y:Number;
		
		public function RiVec(x:Number=0, y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function copy(v:RiVec):void
		{
			this.x = v.x;
			this.y = v.y;
		}
		
		public function getCopy():RiVec
		{
			return new RiVec(x,y);
		}
		
		public function zero():void
		{
			this.x = 0;
			this.y = 0;
		}
		
		public function add(v:RiVec):void
		{
			this.x += v.x;
			this.y += v.y;
		}
		
		public function getAdded(v:RiVec):RiVec
		{
			return new RiVec(this.x + v.x, this.y + v.y);
		}
		
		public function addScaled(v:RiVec, s:Number):void
		{
			this.x += v.x * s;
			this.y += v.y * s;
		}
		
		public function getAddedScaled(v:RiVec, s:Number):RiVec
		{
			return new RiVec(this.x + v.x * s, this.y + v.y * s);
		}
		
		public function sub(v:RiVec):void
		{
			this.x -= v.x;
			this.y -= v.y;
		}
		
		public function getSubbed(v:RiVec):RiVec
		{
			return new RiVec(this.x - v.x, this.y - v.y);
		}
		
		public function scale(s:Number):void
		{
			this.x *= s;
			this.y *= s;
		}
		
		public function getScaled(s:Number):RiVec
		{
			return new RiVec(this.x * s, this.y * s);
		}
		
		public function getLength():Number
		{
			return Math.sqrt(x*x + y*y);
		}
		
		public function getLengthSquared():Number
		{
			return x*x + y*y;
		}
		
		public function normalize():void
		{
			var l:Number = this.getLength();
			if(l > 0)
			{
				this.x /= l;
				this.y /= l;
			}
		}
		
		public function getNormalized():RiVec
		{
			var l:Number = this.getLength();
			if(l > 0)
			{
				return new RiVec(x/l, y/l);
			}
			else
			{
				return new RiVec(0, 0);
			}
		}
		
		public function orthogonalize():void
		{
			var xx:Number = this.x;
			this.x = this.y;
			this.y = -xx;
		}
		
		public function getOrthogonalized():RiVec
		{
			return new RiVec(y, -x);
		}
		
		public function dot(v:RiVec):Number
		{
			return this.x * v.x + this.y * v.y;
		}
		
		public function cross(v:RiVec):Number
		{
			return this.x * v.y - this.y * v.x;
		}
	}
}