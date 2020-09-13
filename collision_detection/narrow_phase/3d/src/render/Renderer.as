package render
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import math.Mat4;
	import math.Quaternion;
	import math.Vec4;
	
	import render.Line;
	
	/**
	 * ...
	 * @author ttrkaya
	 */
	public class Renderer extends Sprite 
	{
		private var _verticies:Vector.<Vec4>;
		private var _transformedVerticies:Vector.<Vec4>;
		private var _cubeTransformers:Vector.<CubeTransformer>;
		private var _renderObjects:Vector.<RenderObject>;
		
		private var _perspective:Quaternion;
		private var _cameraPosInv:Vec4;
		
		private var _ambientLightRatio:Number;
		private var _lightDirection:Vec4;
		
		public function Renderer() 
		{
			_verticies = new Vector.<Vec4>;
			_cubeTransformers = new Vector.<CubeTransformer>;
			_transformedVerticies = new Vector.<Vec4>;
			_renderObjects = new Vector.<RenderObject>;
			
			_perspective = new Quaternion();
			_cameraPosInv = new Vec4(0,0,0);
			
			_ambientLightRatio = 0.2;
			_lightDirection = new Vec4(1,1,1,0);
			_lightDirection.normalize();
		}
		
		public function render():void
		{
			var i:int, li:int;

			this.resetTransformedVerticies();
			this.transformCubes();
			this.perspect();
			this.updateRenderColors();
			this.sortRenderObjects();
			
			this.graphics.clear();
			this.graphics.beginFill(0x111133);
			this.graphics.drawRect(-1000,-1000,2000,2000);
			this.graphics.endFill();
			for(i=0, li=_renderObjects.length; i<li; i++)
			{
				_renderObjects[i].render(this.graphics, _transformedVerticies);
			}
		}
		
		public function setCameraPos(x:Number, y:Number, z:Number):void
		{
			_cameraPosInv.x = -x;
			_cameraPosInv.y = -y;
			_cameraPosInv.z = -z;
		}
		
		public function rotateCamera(rotation:Vec4, scale:Number):void
		{
			_perspective.addScaledVector(rotation, scale);
			_perspective.normalise();
		}
		
		public function resetCameraOrientation():void
		{
			_perspective = new Quaternion();
		}
		
		public function addLine(vertex1:Vec4, vertex2:Vec4, width:Number, color:uint, alpha:Number):Line
		{
			_verticies.push(vertex1);
			_verticies.push(vertex2);
			
			_transformedVerticies = new Vector.<Vec4>(_verticies.length);
			
			var line:Line = new Line(_verticies.length-2, _verticies.length-1, width, color, alpha);
			_renderObjects.push(line);
			
			return line;
		}
		
		public function addCube(c:Vec4, hw:Number, hh:Number, hd:Number, color:uint, alpha:Number):CubeTransformer
		{
			_verticies.push(new Vec4(+hw, +hh, +hd));
			_verticies.push(new Vec4(+hw, +hh, -hd));
			_verticies.push(new Vec4(+hw, -hh, +hd));
			_verticies.push(new Vec4(+hw, -hh, -hd));
			_verticies.push(new Vec4(-hw, +hh, +hd));
			_verticies.push(new Vec4(-hw, +hh, -hd));
			_verticies.push(new Vec4(-hw, -hh, +hd));
			_verticies.push(new Vec4(-hw, -hh, -hd));
			
			_transformedVerticies = new Vector.<Vec4>(_verticies.length);
			
			var l:int = _verticies.length;
			
			_renderObjects.push(new Polygon(new <int>[l-8, l-7, l-5, l-6], color, alpha));
			_renderObjects.push(new Polygon(new <int>[l-2, l-1, l-3, l-4], color, alpha));
			_renderObjects.push(new Polygon(new <int>[l-4, l-3, l-7, l-8], color, alpha));
			_renderObjects.push(new Polygon(new <int>[l-3, l-1, l-5, l-7], color, alpha));
			_renderObjects.push(new Polygon(new <int>[l-2, l-4, l-8, l-6], color, alpha));
			_renderObjects.push(new Polygon(new <int>[l-6, l-5, l-1, l-2], color, alpha));
			
			var vertexIndicies:Vector.<int> = new <int>[l-8, l-7, l-6, l-5, l-4, l-3, l-2, l-1];
			var cubeTransformer:CubeTransformer = new CubeTransformer(vertexIndicies);
			cubeTransformer.pos = c;
			cubeTransformer.hw = hw;
			cubeTransformer.hh = hh;
			cubeTransformer.hd = hd;
			_cubeTransformers.push(cubeTransformer);
			
			return cubeTransformer;
		}
		
		public function addSphere(center:Vec4, r:Number, color:uint, alpha:Number):Vec4
		{
			_verticies.push(center);
			
			var sphere:Sphere = new Sphere(_verticies.length-1, r, color, alpha);
			_renderObjects.push(sphere);
			
			return center;
		}
		
		private function resetTransformedVerticies():void
		{
			var i:int, li:int;
			
			for(i=0, li=_verticies.length; i<li; i++)
			{
				_transformedVerticies[i] = _verticies[i].clone();
			}
		}
		
		private function transformCubes():void
		{
			var i:int, li:int;
			
			for(i=0, li=_cubeTransformers.length; i<li; i++)
			{
				_cubeTransformers[i].transform(_transformedVerticies);
			}
		}
		
		private function perspect():void
		{
			var i:int, li:int;
			
			var perspectiveMatrix:Mat4 = _perspective.getRotationMatrix();
			perspectiveMatrix.setPosition(_cameraPosInv);
			
			for(i=0, li=_verticies.length; i<li; i++)
			{
				var vertex:Vec4 = _transformedVerticies[i];
				perspectiveMatrix.transform(vertex);
				vertex.scaleS();
			}
		}
		
		private function updateRenderColors():void
		{
			var i:int, li:int;
			
			var perspectedLightDirection:Vec4 = _perspective.getRotationMatrix().getTransformed(_lightDirection);
			
			for(i=0, li=_renderObjects.length; i<li; i++)
			{
				_renderObjects[i].updateLightedColor(_transformedVerticies, perspectedLightDirection, _ambientLightRatio);
			}
		}
		
		private function sortRenderObjects():void
		{
			var i:int, li:int;
			
			for(i=0, li=_renderObjects.length; i<li; i++)
			{
				_renderObjects[i].updateSortZ(_transformedVerticies);
			}
			
			_renderObjects = _renderObjects.sort(renderObjectSortHelperFunction);
		}
		private function renderObjectSortHelperFunction(a:RenderObject, b:RenderObject):Number
		{
			return b.sortZ - a.sortZ;
		}
		
	}

}