package  
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class QuadNode 
	{
		public var bodies:Vector.<AABB>;
		public var children:Vector.<QuadNode>;
		
		public function QuadNode() 
		{
			
		}
		
		public function divide():void
		{
			children = new Vector.<QuadNode>(4);
			children[0] = new QuadNode();
			children[1] = new QuadNode();
			children[2] = new QuadNode();
			children[3] = new QuadNode();
		}
		
	}

}