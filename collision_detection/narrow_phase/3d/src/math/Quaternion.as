package math
{
	public class Quaternion
	{
		public var r:Number;
		public var i:Number;
		public var j:Number;
		public var k:Number;
		
		public function Quaternion(r:Number=1, i:Number=0, j:Number=0, k:Number=0)
		{
			this.r = r;
			this.i = i;
			this.j = j;
			this.k = k;
		}
		
		public function clone():Quaternion
		{
			return new Quaternion(r,i,j,k);
		}
		
		public function copy(q:Quaternion):void
		{
			r = q.r;
			i = q.i;
			j = q.j;
			k = q.k;
		}
		
		public function normalise():void
		{
			var invLength:Number = 1/Math.sqrt(r*r + i*i + j*j + k*k);
			this.r *= invLength;
			this.i *= invLength;
			this.j *= invLength;
			this.k *= invLength;
		}
		
		public function multiply(q:Quaternion):void
		{
			var nr:Number = r*q.r - i*q.i - j*q.j - k*q.k;
			var ni:Number = r*q.i + i*q.r + j*q.k - k*q.j;
			var nj:Number = r*q.j - i*q.k + j*q.r + k*q.i;
			var nk:Number = r*q.k + i*q.j - j*q.i + k*q.r;
			
			this.r = nr;
			this.i = ni;
			this.j = nj;
			this.k = nk;
		}
		
		public function addScaledVector(v:Vec4, scale:Number):void
		{
			var q:Quaternion = new Quaternion(0, v.x*scale, v.y*scale, v.z*scale);
			q.multiply(this);
			
			this.r += q.r * 0.5;
			this.i += q.i * 0.5;
			this.j += q.j * 0.5;
			this.k += q.k * 0.5;
		}
		
		public function getRotationMatrix():Mat4
		{
			var mat:Mat4 = new Mat4();
			mat.setOrientation(this);
			return mat;
		}
		
		public function getAnyNormal():Vec4 
		{
			return new Vec4(2 * (i*j + k*r),
							1 - 2*(i*i + k*k),
							2 * (j*k - i*r),
							0);
		}
		
		public function getAnyInverseNormal():Vec4
		{
			return new Vec4(2 * (i*j - k*r),
							1 - 2*(i*i + k*k),
							2 * (j*k + i*r),
							0);
		}
		
		public function getAxis(axisId:int):Vec4
		{
			if(axisId == 0) return new Vec4(
				1 - 2*(j*j + k*k),
				2 * (i*j - k*r),
				2 * (i*k + j*r));
			
			if(axisId == 1) return new Vec4(
				2 * (i*j + k*r),
				1 - 2*(i*i + k*k),
				2 * (j*k - i*r));
			
			if(axisId == 2) return new Vec4(
				2 * (i*k - j*r),
				2 * (j*k + i*r),
				1 - 2*(i*i + j*j));
			
			return null;
		}
	}
}