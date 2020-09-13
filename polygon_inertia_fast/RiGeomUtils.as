package 
{
	public class RiGeomUtils
	{
		public static function getAverage(vertices:Vector.<RiVec>):RiVec
		{
			var i:int, l:int;
			
			var center:RiVec = new RiVec(0, 0);
			for(i=0, l=vertices.length; i<l; i++)
			{
				center.add(vertices[i]);
			}
			center.scale(1/l);
			
			return center;
		}
		
		public static function getCenterOfTriangle(v0:RiVec, v1:RiVec, v2:RiVec):RiVec
		{
			return new RiVec(
				(v0.x + v1.x + v2.x) / 3,
				(v0.y + v1.y + v2.y) / 3
			);				
		}
		
		public static function getTriangleArea(v0:RiVec, v1:RiVec, v2:RiVec):Number
		{
			return Math.abs(v0.x*(v1.y-v2.y)+v1.x*(v2.y-v0.y)+v2.x*(v0.y-v1.y))/2;
		}
		
		public static function isPointInsidePolygon(o:RiVec, poly:Vector.<RiVec>):Boolean
		{
			var i:int, l:int;
			
			var r:Boolean = false;
			for(i=0, l=poly.length; i<l; i++)
			{
				var p:RiVec = poly[i];
				var q:RiVec = poly[(i+1)%l];
				
				if ((p.y <= o.y && o.y < q.y || 
					q.y <= o.y && o.y < p.y) &&
					o.x < p.x + (q.x - p.x) * (o.y - p.y) / (q.y - p.y))
					r = !r;
			}
			
			return r;
		}
		
		public static function getLineSegmentsIntersectionPoint(v00:RiVec, v01:RiVec, v10:RiVec, v11:RiVec):RiVec
		{
			var dir0:RiVec = v01.getSubbed(v00);
			var dir1:RiVec = v11.getSubbed(v10);
			var dirCross:Number = dir1.cross(dir0);
			
			if(dirCross == 0) return null;
			
			var d00:RiVec = v00.getSubbed(v10);
			var t:Number = d00.cross(dir0) / dirCross;
			
			if(t < 0) return null;
			if(t > 1) return null;
			
			var u:Number = d00.cross(dir1) / dirCross;
			
			if(u < 0) return null;
			if(u > 1) return null;
			
			return v00.getAdded(dir0.getScaled(u));
		}
	}
}