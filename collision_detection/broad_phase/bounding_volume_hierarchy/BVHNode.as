package  
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class BVHNode 
	{
		public var area:AABB;
		public var child0:BVHNode;
		public var child1:BVHNode;
		public var body:AABB;
		
		public function BVHNode() 
		{
			area = new AABB(Number.MAX_VALUE, Number.MAX_VALUE, - Number.MAX_VALUE, -Number.MAX_VALUE);
		}
	}

}