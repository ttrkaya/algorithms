package 
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Line 
	{
		public var a:Vec2;
		public var b:Vec2;
		
		public function Line(ax:Number, ay:Number, bx:Number, by:Number) 
		{
			a = new Vec2(ax, ay);
			b = new Vec2(bx, by);
		}
		
		public function intersects(l:Line):Boolean
		{
			var d:Vec2 = b.subs(a);
			var da:Vec2 = l.a.subs(a);
			var db:Vec2 = l.b.subs(a);
			if (d.cross(da) * d.cross(db) > 0) return false;
			
			var ld:Vec2 = l.b.subs(l.a);
			var lda:Vec2 = a.subs(l.a);
			var ldb:Vec2 = b.subs(l.a);
			if (ld.cross(lda) * ld.cross(ldb) > 0) return false;
			
			return true;
		}
		
		public function getIntersection(l:Line):Vec2
		{
			var d:Vec2 = b.subs(a);
			var ld:Vec2 = l.b.subs(l.a);
			
			var dc:Number = d.cross(ld);
			//if (dc == 0) return null;
			
			var laa:Vec2 = l.a.subs(a);
			
			var u:Number = laa.cross(ld) / dc;
			return new Vec2(a.x + d.x * u, a.y + d.y * u);
		}
		
		public function normalize(toScale:Number = 1):void
		{
			var d:Vec2 = b.subs(a);
			d.normalize();
			b.x = a.x + d.x * toScale;
			b.y = a.y + d.y * toScale;
		}
	}

}