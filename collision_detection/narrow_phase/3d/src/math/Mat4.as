package math
{
	import flash.sensors.Accelerometer;

	public class Mat4
	{
		public var a1:Number;
		public var a2:Number;
		public var a3:Number;
		public var a4:Number;
		public var b1:Number;
		public var b2:Number;
		public var b3:Number;
		public var b4:Number;
		public var c1:Number;
		public var c2:Number;
		public var c3:Number;
		public var c4:Number;
		public var d1:Number;
		public var d2:Number;
		public var d3:Number;
		public var d4:Number;
		
		public function Mat4(a1:Number=1, a2:Number=0, a3:Number=0, a4:Number=0, 
							 b1:Number=0, b2:Number=1, b3:Number=0, b4:Number=0, 
							 c1:Number=0, c2:Number=0, c3:Number=1, c4:Number=0,  
							 d1:Number=0, d2:Number=0, d3:Number=0, d4:Number=1)
		{
			this.a1 = a1;
			this.a2 = a2;
			this.a3 = a3;
			this.a4 = a4;
			this.b1 = b1;
			this.b2 = b2;
			this.b3 = b3;
			this.b4 = b4;
			this.c1 = c1;
			this.c2 = c2;
			this.c3 = c3;
			this.c4 = c4;
			this.d1 = d1;
			this.d2 = d2;
			this.d3 = d3;
			this.d4 = d4;
		}
		
		public function clone():Mat4
		{
			return new Mat4(a1,a2,a3,a4,b1,b2,b3,b4,c1,c2,c3,c4,d1,d2,d3,d4);
		}
		
		public function getTransformed(v:Vec4):Vec4
		{
			return new Vec4(a1*v.x + a2*v.y + a3*v.z + a4*v.s,
							b1*v.x + b2*v.y + b3*v.z + b4*v.s,
							c1*v.x + c2*v.y + c3*v.z + c4*v.s,
							d1*v.x + d2*v.y + d3*v.z + d4*v.s);
		}
		
		public function transform(v:Vec4):void
		{
			var nx:Number = a1*v.x + a2*v.y + a3*v.z + a4*v.s;
			var ny:Number = b1*v.x + b2*v.y + b3*v.z + b4*v.s;
			var nz:Number = c1*v.x + c2*v.y + c3*v.z + c4*v.s;
			var ns:Number = d1*v.x + d2*v.y + d3*v.z + d4*v.s;
			
			v.x = nx;
			v.y = ny;
			v.z = nz;
			v.s = ns;
		}
		
		public function getInverseTransformed(v:Vec4):Vec4
		{
			var tx:Number = v.x - a4*v.s;
			var ty:Number = v.y - b4*v.s;
			var tz:Number = v.z - c4*v.s;
			
			var nx:Number = a1*tx + b1*ty + c1*tz;
			var ny:Number = a2*tx + b2*ty + c2*tz;
			var nz:Number = a3*tx + b3*ty + c3*tz;
			
			return new Vec4(nx, ny, nz, v.s);
		}
		
		public function inverseTransform(v:Vec4):void
		{
			var tx:Number = v.x - a4*v.s;
			var ty:Number = v.y - b4*v.s;
			var tz:Number = v.z - c4*v.s;
			
			v.x = a1*tx + b1*ty + c1*tz;
			v.y = a2*tx + b2*ty + c2*tz;
			v.z = a3*tx + b3*ty + c3*tz;
		}
		
		public function setOrientation(q:Quaternion):void
		{
			a1 = 1 - 2*(q.j*q.j + q.k*q.k);
			a2 = 2 * (q.i*q.j + q.k*q.r);
			a3 = 2 * (q.i*q.k - q.j*q.r);
			
			b1 = 2 * (q.i*q.j - q.k*q.r);
			b2 = 1 - 2*(q.i*q.i + q.k*q.k);
			b3 = 2 * (q.j*q.k + q.i*q.r);
			
			c1 = 2 * (q.i*q.k + q.j*q.r);
			c2 = 2 * (q.j*q.k - q.i*q.r);
			c3 = 1 - 2*(q.i*q.i + q.j*q.j);
		}
		
		public function setPosition(v:Vec4):void
		{
			a4 = v.x;
			b4 = v.y;
			c4 = v.z;
		}
		
		public function inverseAsTransform():void
		{
			var t:Number;
			
			//FIRST inverse the translation
			var na1:Number = -a1*a4 -b1*b4 -c1*c4;
			var nb1:Number = -a2*a4 -b2*b4 -c2*c4;
			var nc1:Number = -a3*a4 -b3*b4 -c3*c4;
				
			a4 = na1;
			b4 = nb1;
			c4 = nc1;
			
			//transpose the rotation
			t = a2;
			a2 = b1;
			b1 = t;
			
			t = a3;
			a3 = c1;
			c1 = t;
			
			t = b3;
			b3 = c2;
			c2 = t;
		}
		
		public function inverseAs3x3():void
		{
			var t1:Number = a1*b2;
			var t2:Number = a1*b3;
			var t3:Number = a2*b1;
			var t4:Number = a3*b1;
			var t5:Number = a2*c1;
			var t6:Number = a3*c1;
			
			// Calculate the determinant
			var det:Number = t1*c3 - t2*c2 - t3*c3+ t4*c2 + t5*b3 - t6*b2;
			
			// Make sure the determinant is non-zero.
			if (det == 0) return;
			var invDet:Number = 1/det;
			
			var na1:Number = (b2*c3-b3*c2)*invDet;
			var na2:Number = -(a2*c3-a3*c2)*invDet;
			var na3:Number = (a2*b3-a3*b2)*invDet;
			var nb1:Number = -(b1*c3-b3*c1)*invDet;
			var nb2:Number = (a1*c3-t6)*invDet;
			var nb3:Number = -(t2-t4)*invDet;
			var nc1:Number = (b1*c2-b2*c1)*invDet;
			var nc2:Number = -(a1*c2-t5)*invDet;
			var nc3:Number = (t1-t3)*invDet;
			
			a1 = na1;
			a2 = na2;
			a3 = na3;
			b1 = nb1;
			b2 = nb2;
			b3 = nb3;
			c1 = nc1;
			c2 = nc2;
			c3 = nc3;
		}
	}
}