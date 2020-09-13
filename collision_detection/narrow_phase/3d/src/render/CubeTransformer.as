package render
{
	import math.Mat4;
	import math.Quaternion;
	import math.Vec4;

	public class CubeTransformer
	{
		private var _vertexIndicies:Vector.<int>;
		
		public var pos:Vec4;
		public var orientation:Quaternion;
		
		public var hw:Number;
		public var hh:Number;
		public var hd:Number;
		
		public function CubeTransformer(vertexIndicies:Vector.<int>)
		{
			_vertexIndicies = vertexIndicies;
			
			pos = new Vec4(0,0,0);
			orientation = new Quaternion();
		}
		
		public function transform(transformedVerticies:Vector.<Vec4>):void
		{
			var i:int, li:int;
			
			var transformMatrix:Mat4 = orientation.getRotationMatrix();
			transformMatrix.setPosition(pos);
			
			for(i=0, li=_vertexIndicies.length; i<li; i++)
			{
				var vertex:Vec4 = transformedVerticies[_vertexIndicies[i]];
				transformMatrix.transform(vertex);
			}
		}
		
		public function getTransformMatrix():Mat4
		{
			var transformMatrix:Mat4 = orientation.getRotationMatrix();
			transformMatrix.setPosition(pos);
			return transformMatrix;
		}
		
		public function rotate(rotation:Vec4, scale:Number):void
		{
			orientation.addScaledVector(rotation, scale);
			orientation.normalise();
		}
		
		public function translate(x:Number, y:Number, z:Number):void
		{
			pos.x += x;
			pos.y += y;
			pos.z += z;
		}
	}
}