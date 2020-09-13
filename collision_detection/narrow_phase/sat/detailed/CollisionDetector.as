package
{
	import flash.geom.Point;

	public class CollisionDetector
	{
		private static const ERR:Number = 0.000000001;
		
		public static function getCollision(polygon0:Vector.<P>, polygon1:Vector.<P>):CollisionData
		{
			var i:int, j:int;
			
			var dirs:Vector.<Point> = new Vector.<Point>;
			for(i=0; i<polygon0.length; i++) dirs.push(getDir(polygon0,i));
			for(i=0; i<polygon1.length; i++) dirs.push(getDir(polygon1,i));
			
			var ranges0:Vector.<Range1D> = new Vector.<Range1D>;
			var ranges1:Vector.<Range1D> = new Vector.<Range1D>;
			for(i=0; i<dirs.length; i++)
			{
				ranges0.push(getRangesInDir(polygon0, dirs[i]));
				ranges1.push(getRangesInDir(polygon1, dirs[i]));
			}
			
			var collidingDirIndex:int = -1;
			var minPenetration:Number = Number.MAX_VALUE;
			var collidingVertexIndex0:int;
			var collidingVertexIndex1:int;
			for(i=0; i<dirs.length; i++)
			{
				if(ranges0[i].max < ranges1[i].min || ranges1[i].max < ranges0[i].min)
				{
					collidingDirIndex = -1;
					break;
				}
				
				var penetration:Number;
				var currCollidingVertexIndex0:int;
				var currCollidingVertexIndex1:int;
				if(ranges0[i].min < ranges1[i].min)
				{
					penetration = ranges0[i].max - ranges1[i].min;
					currCollidingVertexIndex0 = ranges0[i].maxVertexIndex;
					currCollidingVertexIndex1 = ranges1[i].minVertexIndex;
				}
				else
				{
					penetration = ranges1[i].max - ranges0[i].min;
					currCollidingVertexIndex0 = ranges0[i].minVertexIndex;
					currCollidingVertexIndex1 = ranges1[i].maxVertexIndex;
				}
				
				if(penetration < minPenetration)
				{
					minPenetration = penetration;
					collidingDirIndex = i;
					collidingVertexIndex0 = currCollidingVertexIndex0;
					collidingVertexIndex1 = currCollidingVertexIndex1;
				}
			}
			
			if(collidingDirIndex < 0) return null;
			
			var colData:CollisionData = new CollisionData();
			colData.penetration = minPenetration;
			
			var isPolyOfVertexFirst:Boolean = (collidingDirIndex >= polygon0.length);
			
			var collidingVertex:P;
			if(isPolyOfVertexFirst)
			{
				collidingVertex = polygon0[collidingVertexIndex0];
			}
			else
			{
				collidingVertex = polygon1[collidingVertexIndex1];
			}
			colData.pos = new Point(collidingVertex.x, collidingVertex.y);
			
			
			var collidingDir:Point = dirs[collidingDirIndex];
			colData.normal = collidingDir;
			
			var polyOfVertex:Vector.<P> = isPolyOfVertexFirst ? polygon0 : polygon1;
			var polyOfVertexCenter:Point = new Point();
			for(i=0; i<polyOfVertex.length; i++)
			{
				polyOfVertexCenter.x += polyOfVertex[i].x;
				polyOfVertexCenter.y += polyOfVertex[i].y;
			}
			polyOfVertexCenter.x /= polyOfVertex.length;
			polyOfVertexCenter.y /= polyOfVertex.length;
			
			if(
				(colData.pos.x - polyOfVertexCenter.x) * colData.normal.x + 
				(colData.pos.y - polyOfVertexCenter.y) * colData.normal.y > 0
			)
			{
				colData.normal.x *= -1;
				colData.normal.y *= -1;
			}
			
			return colData;
		}
		
		private static function getDir(polygon:Vector.<P>, i:int):Point
		{
			var i1:int = (i+1) % polygon.length;
			
			var v0:P = polygon[i];
			var v1:P = polygon[i1];
			
			var dir:Point = new Point(v1.y-v0.y, -(v1.x-v0.x));
			dir.normalize(1);
			
			return dir;
		}
		
		private static function getRangesInDir(pol:Vector.<P>, dir:Point):Range1D
		{
			var i:int;
			
			var range:Range1D = new Range1D();
			range.min = Number.MAX_VALUE;
			range.max = -Number.MAX_VALUE;
			for(i=0; i<pol.length; i++)
			{
				var vertex:P = pol[i];
				var proj:Number = vertex.x * dir.x + vertex.y * dir.y;
				if(proj < range.min)
				{
					range.min = proj;
					range.minVertexIndex = i;
				}
				if(proj > range.max)
				{
					range.max = proj;
					range.maxVertexIndex = i;
				}
			}
			
			return range;
		}
	}
}