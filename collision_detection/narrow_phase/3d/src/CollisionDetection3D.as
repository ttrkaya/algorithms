package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import math.Mat4;
	import math.Vec4;
	
	import render.CubeTransformer;
	import render.Renderer;
	import render.Sphere;
	
	[SWF(width="400", height="400", frameRate="60",backgroundColor="#888888")]
	public class CollisionDetection3D extends Sprite
	{
		private var _renderer:Renderer;
		
		private var _sphereCenter0:Vec4;
		private var _sphereR0:Number;
		private var _sphereCenter1:Vec4;
		private var _sphereR1:Number;
		
		private var _cube0:CubeTransformer;
		private var _cube1:CubeTransformer;
		
		private var _lineVertices:Vector.<Vec4>;
		
		private var _lastUpdatedTime:Number;
		
		private var _isMouseDown:Boolean;
		private var _contolledId:int;
		private var _keys:Object;
		
		private static const SW:Number = 400;
		private static const SH:Number = 400;
		
		public function CollisionDetection3D()
		{
			var i:int;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_renderer = new Renderer();
			_renderer.setCameraPos(0,0,-300);
			this.addChild(_renderer);
			_renderer.x = SW/2;
			_renderer.y = SH/2;
			
			//center
			_renderer.addSphere(new Vec4(0 ,0, 0), 3, 0xff0000, 0.5); 
			
			_sphereCenter0 = new Vec4(0,0,100);
			_sphereR0 = 30;
			_sphereCenter1 = new Vec4(100,0,100);
			_sphereR1 = 50;
			
			_renderer.addSphere(_sphereCenter0, _sphereR0, 0x00ff00, 0.5);
			_renderer.addSphere(_sphereCenter1, _sphereR1, 0x00ff00, 0.5);
			
			_cube0 = _renderer.addCube(new Vec4(-100, 0, 100), 40, 40, 40, 0x00ff00, 0.5);
			_cube1 = _renderer.addCube(new Vec4(-100, 130, 100), 40, 40, 40, 0x00ff00, 0.5);
			_cube0.rotate(new Vec4(1,0,0), 1);
			_cube1.rotate(new Vec4(0,0,1), 1);
			
			_lineVertices = new Vector.<Vec4>;
			for(i=0; i<20; i++)
			{
				_lineVertices.push(new Vec4(0,0,0));
			}
			for(i=0; i<_lineVertices.length; i+=2)
			{
				_renderer.addLine(_lineVertices[i], _lineVertices[i+1], 2, 0xff0000, 1);
			}
			
			_isMouseDown = false;
			_contolledId = 2;
			_keys = new Object();
			
			_lastUpdatedTime = getNow();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var i:int;
			
			var now:Number = getNow();
			var dt:Number = now - _lastUpdatedTime;
			_lastUpdatedTime = now;
			
			var sphereCenterToControl:Vec4;
			if(_contolledId == 0) sphereCenterToControl = _sphereCenter0;
			else if(_contolledId == 1) sphereCenterToControl = _sphereCenter1;
			
			var cubeToControl:CubeTransformer;
			if(_contolledId == 2) cubeToControl = _cube0;
			else if(_contolledId == 3) cubeToControl = _cube1;
			
			const controlSpeed:Number = 30;
			if(_keys[Keyboard.A])
			{
				if(sphereCenterToControl) sphereCenterToControl.x -= controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.x -= controlSpeed * dt;
			}
			if(_keys[Keyboard.D])
			{
				if(sphereCenterToControl) sphereCenterToControl.x += controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.x += controlSpeed * dt;
			}
			if(_keys[Keyboard.W])
			{
				if(sphereCenterToControl) sphereCenterToControl.z += controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.z += controlSpeed * dt;
			}
			if(_keys[Keyboard.S])
			{
				if(sphereCenterToControl) sphereCenterToControl.z -= controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.z -= controlSpeed * dt;
			}
			if(_keys[Keyboard.Q])
			{
				if(sphereCenterToControl) sphereCenterToControl.y += controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.y += controlSpeed * dt;
			}
			if(_keys[Keyboard.E])
			{
				if(sphereCenterToControl) sphereCenterToControl.y -= controlSpeed * dt;
				if(cubeToControl) cubeToControl.pos.y -= controlSpeed * dt;
			}
			if(_keys[Keyboard.Z])
			{
				if(cubeToControl) cubeToControl.rotate(new Vec4(0,0,1), dt);
			}
			if(_keys[Keyboard.X])
			{
				if(cubeToControl) cubeToControl.rotate(new Vec4(1,0,0), dt);
			}
			if(_keys[Keyboard.C])
			{
				if(cubeToControl) cubeToControl.rotate(new Vec4(0,1,0), dt);
			}
			
			if(_isMouseDown)
			{
				var mdx:Number = this.mouseX - SW/2;
				var mdy:Number = this.mouseY - SH/2;
				_renderer.rotateCamera(new Vec4(-mdy,-mdx,0), dt*0.01);
			}
			
			for(i=0; i<_lineVertices.length; i++)
			{
				_lineVertices[i].zero();
			}
			
			//sphere-sphere
			if(_sphereCenter1.getSubbed(_sphereCenter0).length() < (_sphereR0 + _sphereR1))
			{
				var ssNormal:Vec4 = _sphereCenter1.getSubbed(_sphereCenter0);
				ssNormal.normalize();
				var ssPenetration:Number = _sphereR0 + _sphereR1 - _sphereCenter1.getSubbed(_sphereCenter0).length();
				var ssColPoint:Vec4 = _sphereCenter0.getAdded(ssNormal.getScaled(_sphereR0 - ssPenetration/2));
				
				_lineVertices[0].copy(ssColPoint);
				_lineVertices[1].copy(ssColPoint.getAdded(ssNormal.getScaled(ssPenetration)));
			}
			
			checkCubeSphere(_sphereCenter0, _sphereR0, _cube0);
			checkCubeSphere(_sphereCenter0, _sphereR0, _cube1);
			checkCubeSphere(_sphereCenter1, _sphereR1, _cube0);
			checkCubeSphere(_sphereCenter1, _sphereR1, _cube1);
			
			//cube-cube (SAT algorithm)
			var face0x:Vec4 = _cube0.orientation.getAxis(0);
			var face0y:Vec4 = _cube0.orientation.getAxis(1);
			var face0z:Vec4 = _cube0.orientation.getAxis(2);
			var face1x:Vec4 = _cube1.orientation.getAxis(0);
			var face1y:Vec4 = _cube1.orientation.getAxis(1);
			var face1z:Vec4 = _cube1.orientation.getAxis(2);
			var edgexx:Vec4 = face0x.cross(face1x);
			edgexx.normalize();
			var edgexy:Vec4 = face0x.cross(face1y);
			edgexy.normalize();
			var edgexz:Vec4 = face0x.cross(face1z);
			edgexz.normalize();
			var edgeyx:Vec4 = face0y.cross(face1x);
			edgeyx.normalize();
			var edgeyy:Vec4 = face0y.cross(face1y);
			edgeyy.normalize();
			var edgeyz:Vec4 = face0y.cross(face1z);
			edgeyz.normalize();
			var edgezx:Vec4 = face0z.cross(face1x);
			edgezx.normalize();
			var edgezy:Vec4 = face0z.cross(face1y);
			edgezy.normalize();
			var edgezz:Vec4 = face0z.cross(face1z);
			edgezz.normalize();
			
			var axes:Vector.<Vec4> = new <Vec4>[face0x, face0y, face0z, face1x, face1y, face1z, 
											edgexx, edgexy, edgexz, edgeyx, edgeyy, edgeyz, edgezx, edgezy, edgezz];
			
			var minPenetration:Number = Number.MAX_VALUE;
			var minPenetrationIndex:int = -1;
			for(i=0; i<15; i++)
			{
				var axis:Vec4 = axes[i];
				if(axis.isZero()) continue;
				
				var limit0:Point = getLimits1D(_cube0, axis);
				var limit1:Point = getLimits1D(_cube1, axis);
				
				if(limit0.x > limit1.y || limit0.y < limit1.x)
				{
					minPenetration = -1;
					break;
				}
				else
				{
					var penetration:Number = Math.min(Math.abs(limit0.x-limit1.y), Math.abs(limit0.y-limit1.x));
					if(penetration < minPenetration)
					{
						minPenetration = penetration;
						minPenetrationIndex = i;
					}
				}
			}
			
			if(minPenetration > 0) 
			{
				var ccPenetration:Number = minPenetration;
				var ccColPoint:Vec4;
				var ccNormal:Vec4;
				
				if(minPenetrationIndex < 6) //face-vertex
				{
					var cubeOfVertex:CubeTransformer;
					var cubeOfFace:CubeTransformer;
					if(minPenetrationIndex < 3)//face of cube0, vertex of cube1
					{
						cubeOfFace = _cube0;
						cubeOfVertex = _cube1;
					}
					else //vertex of cube0, face of cube1
					{
						cubeOfVertex = _cube0;
						cubeOfFace = _cube1;
					}
					
					ccColPoint = getClosestVertex(cubeOfVertex, cubeOfFace);
					ccNormal = cubeOfFace.orientation.getAxis(minPenetrationIndex%3);
					if(ccNormal.dot(cubeOfVertex.pos.getSubbed(cubeOfFace.pos)) < 0) ccNormal.scale(-1);
				}
				else //edges of both
				{
					var axis0:Vec4;
					var pointsOnEdges:Vector.<Vec4> = new Vector.<Vec4>(4); 
					if(minPenetrationIndex < 9)
					{
						axis0 = new Vec4(1,0,0,0);
						pointsOnEdges[0] = new Vec4(0, _cube0.hh, _cube0.hd);
						pointsOnEdges[1] = new Vec4(0, _cube0.hh, -_cube0.hd);
						pointsOnEdges[2] = new Vec4(0, -_cube0.hh, _cube0.hd);
						pointsOnEdges[3] = new Vec4(0, -_cube0.hh, -_cube0.hd);
					}
					else if(minPenetrationIndex < 12)
					{
						axis0 = new Vec4(0,1,0,0);
						pointsOnEdges[0] = new Vec4(_cube0.hw, 0, _cube0.hd);
						pointsOnEdges[1] = new Vec4(_cube0.hw, 0, -_cube0.hd);
						pointsOnEdges[2] = new Vec4(-_cube0.hw, 0, _cube0.hd);
						pointsOnEdges[3] = new Vec4(-_cube0.hw, 0, -_cube0.hd);
					}
					else
					{
						axis0 = new Vec4(0,0,1,0);
						pointsOnEdges[0] = new Vec4(_cube0.hw, _cube0.hh, 0);
						pointsOnEdges[1] = new Vec4(_cube0.hw, -_cube0.hh, 0);
						pointsOnEdges[2] = new Vec4(-_cube0.hw, _cube0.hh, 0);
						pointsOnEdges[3] = new Vec4(-_cube0.hw, -_cube0.hh, 0);
					}
					
					var midPointOnEdge0:Vec4;
					var minDist2:Number = Number.MAX_VALUE;
					var transformMat0:Mat4 = _cube0.getTransformMatrix();
					for(i=0; i<4; i++)
					{
						var pointOnEdge:Vec4 = pointsOnEdges[i];
						transformMat0.transform(pointOnEdge);
						var dist2:Number = pointOnEdge.getSubbed(_cube1.pos).lengthSquared();
						if(dist2 < minDist2)
						{
							midPointOnEdge0 = pointOnEdge;
							minDist2 = dist2;
						}
					}
					transformMat0.transform(axis0);
					
					var axis1:Vec4;
					if(minPenetrationIndex%3 == 0)
					{
						axis1 = new Vec4(1,0,0,0);
						pointsOnEdges[0] = new Vec4(0, _cube1.hh, _cube1.hd);
						pointsOnEdges[1] = new Vec4(0, _cube1.hh, -_cube1.hd);
						pointsOnEdges[2] = new Vec4(0, -_cube1.hh, _cube1.hd);
						pointsOnEdges[3] = new Vec4(0, -_cube1.hh, -_cube1.hd);
					}
					if(minPenetrationIndex%3 == 1)
					{
						axis1 = new Vec4(0,1,0,0);
						pointsOnEdges[0] = new Vec4(_cube1.hw, 0, _cube1.hd);
						pointsOnEdges[1] = new Vec4(_cube1.hw, 0, -_cube1.hd);
						pointsOnEdges[2] = new Vec4(-_cube1.hw, 0, _cube1.hd);
						pointsOnEdges[3] = new Vec4(-_cube1.hw, 0, -_cube1.hd);
					}
					else
					{
						axis1 = new Vec4(0,0,1,0);
						pointsOnEdges[0] = new Vec4(_cube1.hw, _cube1.hh, 0);
						pointsOnEdges[1] = new Vec4(_cube1.hw, -_cube1.hh, 0);
						pointsOnEdges[2] = new Vec4(-_cube1.hw, _cube1.hh, 0);
						pointsOnEdges[3] = new Vec4(-_cube1.hw, -_cube1.hh, 0);
					}
					
					var midPointOnEdge1:Vec4;
					minDist2 = Number.MAX_VALUE;
					var transformMat1:Mat4 = _cube1.getTransformMatrix();
					for(i=0; i<4; i++)
					{
						pointOnEdge = pointsOnEdges[i];
						transformMat1.transform(pointOnEdge);
						dist2 = pointOnEdge.getSubbed(_cube0.pos).lengthSquared();
						if(dist2 < minDist2)
						{
							midPointOnEdge1 = pointOnEdge;
							minDist2 = dist2;
						}
					}
					transformMat1.transform(axis1);
					
					ccColPoint = getMidPointBetweenLines(axis0, midPointOnEdge0, axis1, midPointOnEdge1);
					ccNormal = axis0.cross(axis1);
					ccNormal.normalize();
				}
				
				for(i=0; i<_lineVertices.length; i++)
				{
					if(_lineVertices[i].lengthSquared() == 0)
					{
						_lineVertices[i].copy(ccColPoint);
						_lineVertices[i+1].copy(ccColPoint.getAdded(ccNormal.getScaled(ccPenetration)));
						
						break;
					}
				}
			}
			
			_renderer.render();
		}
		
		private function checkCubeSphere(sphereCenter:Vec4, sphereR:Number, cube:CubeTransformer):void
		{
			var i:int;
			
			var cubeTransformMatrix:Mat4 = cube.getTransformMatrix();
			var localSphereCenter:Vec4 = cubeTransformMatrix.getInverseTransformed(sphereCenter);
			
			var closestPoint:Vec4 = localSphereCenter.clone();
			if(closestPoint.x < -cube.hw) closestPoint.x = -cube.hw;
			else if(closestPoint.x > cube.hw) closestPoint.x = cube.hw;
			if(closestPoint.y < -cube.hh) closestPoint.y = -cube.hh;
			else if(closestPoint.y > cube.hh) closestPoint.y = cube.hh;
			if(closestPoint.z < -cube.hd) closestPoint.z = -cube.hd;
			else if(closestPoint.z > cube.hd) closestPoint.z = cube.hd;
			
			var d:Vec4 = localSphereCenter.getSubbed(closestPoint);
			if(d.length() < sphereR)
			{
				var csNormal:Vec4 = d.clone();
				csNormal.normalize();
				csNormal.s = 0;
				var csPenetration:Number = sphereR - d.length();
				
				cubeTransformMatrix.transform(closestPoint);
				cubeTransformMatrix.transform(csNormal);
				
				for(i=0; i<_lineVertices.length; i++)
				{
					if(_lineVertices[i].lengthSquared() == 0)
					{
						_lineVertices[i].copy(closestPoint);
						_lineVertices[i+1].copy(closestPoint.getAdded(csNormal.getScaled(csPenetration)));
						
						break;
					}
				}
			}
		}
		
		private function getLimits1D(cube:CubeTransformer, axis:Vec4):Point
		{
			var i:int;
			
			var transformMat:Mat4 = cube.getTransformMatrix();
			
			var verticies:Vector.<Vec4> = new <Vec4>[ new Vec4(cube.hw, cube.hh, cube.hd),
													new Vec4(cube.hw, cube.hh, -cube.hd),
													new Vec4(cube.hw, -cube.hh, cube.hd),
													new Vec4(cube.hw, -cube.hh, -cube.hd),
													new Vec4(-cube.hw, cube.hh, cube.hd),
													new Vec4(-cube.hw, cube.hh, -cube.hd),
													new Vec4(-cube.hw, -cube.hh, cube.hd),
													new Vec4(-cube.hw, -cube.hh, -cube.hd)];
			
			var min:Number = Number.MAX_VALUE;
			var max:Number = -Number.MAX_VALUE;
			for(i=0; i<8; i++)
			{
				var vertex:Vec4 = verticies[i];
				transformMat.transform(vertex);
				var value1D:Number = axis.dot(vertex);
				
				if(value1D < min) min = value1D;
				if(value1D > max) max = value1D;
			}
			
			return new Point(min,max);
		}
		
		private function getClosestVertex(cubeOfVertex:CubeTransformer, cubeOfFace:CubeTransformer):Vec4
		{
			var i:int;
			
			var transformMat:Mat4 = cubeOfVertex.getTransformMatrix();
			
			var vertices:Vector.<Vec4> = new <Vec4>[ new Vec4(cubeOfVertex.hw, cubeOfVertex.hh, cubeOfVertex.hd),
													new Vec4(cubeOfVertex.hw, cubeOfVertex.hh, -cubeOfVertex.hd),
													new Vec4(cubeOfVertex.hw, -cubeOfVertex.hh, cubeOfVertex.hd),
													new Vec4(cubeOfVertex.hw, -cubeOfVertex.hh, -cubeOfVertex.hd),
													new Vec4(-cubeOfVertex.hw, cubeOfVertex.hh, cubeOfVertex.hd),
													new Vec4(-cubeOfVertex.hw, cubeOfVertex.hh, -cubeOfVertex.hd),
													new Vec4(-cubeOfVertex.hw, -cubeOfVertex.hh, cubeOfVertex.hd),
													new Vec4(-cubeOfVertex.hw, -cubeOfVertex.hh, -cubeOfVertex.hd)];
												
			for(i=0; i<8; i++) transformMat.transform(vertices[i]);
			
			var cubeOfFaceCenter:Vec4 = cubeOfFace.pos;
			var closestVertex:Vec4;
			var minDist2:Number = Number.MAX_VALUE; //minimum distance squared
			for(i=0; i<8; i++)
			{
				var dist2:Number = cubeOfFaceCenter.getSubbed(vertices[i]).lengthSquared();
				if(dist2 < minDist2)
				{
					closestVertex = vertices[i];
					minDist2 = dist2;
				}
			}
			
			return closestVertex;
		}
		
		private function getMidPointBetweenLines(axis0:Vec4, p0:Vec4, axis1:Vec4, p1:Vec4):Vec4
		{
			var dp:Vec4 = p0.getSubbed(p1);
			
			var dpp0:Number = axis0.dot(dp);
			var dpp1:Number = axis1.dot(dp);
			
			var sm0:Number = axis0.lengthSquared();
			var sm1:Number = axis1.lengthSquared();
			var dotEdges:Number = axis0.dot(axis1);
			var denom:Number = sm0 * sm1 - dotEdges*dotEdges;
			var a:Number = (dotEdges * dpp1 - sm1 * dpp0) / denom;
			var b:Number = (sm0 * dpp1 - dotEdges * dpp0) / denom;
			
			var nearest0:Vec4 = p0.getAdded(axis0.getScaled(a));
			var nearest1:Vec4 = p1.getAdded(axis1.getScaled(b));
			var mid:Vec4 = nearest0.getScaled(0.5).getAdded(nearest1.getScaled(0.5));
			
			return mid;
		}
		
		private function getNow():Number { return (new Date()).time / 1000; }
		
		private function onMouseDown(e:MouseEvent):void
		{
			_isMouseDown = true;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_isMouseDown = false;
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.NUMBER_1) _contolledId = 0;
			if(e.keyCode == Keyboard.NUMBER_2) _contolledId = 1;
			if(e.keyCode == Keyboard.NUMBER_3) _contolledId = 2;
			if(e.keyCode == Keyboard.NUMBER_4) _contolledId = 3;
			
			_keys[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			_keys[e.keyCode] = false;
		}
	}
}