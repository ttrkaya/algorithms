package math
{
	public class Vec4
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var s:Number;
		
		public function Vec4(x:Number, y:Number, z:Number, s:Number=1)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.s = s;
		}
		
		public function clone():Vec4
		{
			return new Vec4(x,y,z,s);
		}
		
		public function copy(v:Vec4):void
		{
			this.x = v.x;
			this.y = v.y;
			this.z = v.z;
			this.s = v.s;
		}
		
		public function zero():void
		{
			this.x = 0;
			this.y = 0;
			this.z = 0;
			this.s = 1;
		}
		
		public function isZero():Boolean
		{
			return x==0 && y==0 && z==0;
		}
		
		public function add(v:Vec4):void
		{
			this.x += v.x;
			this.y += v.y;
			this.z += v.z;
		}
		
		public function addScaled(v:Vec4, scale:Number):void
		{
			this.x += v.x * scale;
			this.y += v.y * scale;
			this.z += v.z * scale;
		}
		
		public function getAdded(v:Vec4):Vec4
		{
			return new Vec4(this.x + v.x,
							this.y + v.y,
							this.z + v.z);
			
		}
		
		public function sub(v:Vec4):void
		{
			this.x -= v.x;
			this.y -= v.y;
			this.z -= v.z;
		}
		
		public function getSubbed(v:Vec4):Vec4
		{
			return new Vec4(this.x - v.x,
							this.y - v.y,
							this.z - v.z);
		}
		
		public function scale(n:Number):void
		{
			this.x *= n;
			this.y *= n;
			this.z *= n;
		}
		
		public function getScaled(n:Number):Vec4
		{
			return new Vec4(this.x * n,
							this.y * n,
							this.z * n);
		}
		
		public function scaleS():void
		{
			this.x /= this.s;
			this.y /= this.s;
			this.z /= this.s;
			this.s = 1;
		}
		
		public function lengthSquared():Number
		{
			return x*x + y*y + z*z;
		}
		
		public function length():Number
		{
			return Math.sqrt(x*x + y*y + z*z);
		}
		
		public function normalize():void
		{
			var l:Number = x*x + y*y + z*z;
			if(l == 0) return;
			l = Math.sqrt(l);
			this.x /= l;
			this.y /= l;
			this.z /= l;
		}
		
		public function dot(v:Vec4):Number
		{
			return this.x*v.x + this.y*v.y + this.z*v.z;
		}
		
		public function cross(v:Vec4):Vec4
		{
			return new Vec4(y*v.z - z*v.y,
							z*v.x - x*v.z,
							x*v.y - y*v.x);
		}
	}
}