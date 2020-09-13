package  
{
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Mark 
	{
		public var body:AABB;
		public var value:Number;
		public var isBegin:Boolean;
		
		public function Mark(body:AABB, isBegin:Boolean, isOnAxisX:Boolean) 
		{
			this.body = body;
			this.isBegin = isBegin;
			
			if (isOnAxisX)
			{
				if (isBegin) value = body.minX;
				else value = body.maxX;
			}
			else
			{
				if (isBegin) value = body.minY;
				else value = body.maxY;
			}
		}
		
	}

}