#pragma once

#include "Constants.h"

class Node
{
public:
	int bodyIndex; // -1 = container, [0, numcircles) = circleIndex, [numcircles, numcircles + numlines) = lineindex 
	real minx, miny, maxx, maxy;

	Node() {}
	Node(int bodyIndex_, real minx_, real miny_, real maxx_, real maxy_) : 
		bodyIndex(bodyIndex_), minx(minx_), miny(miny_), maxx(maxx_), maxy(maxy_) {}

	bool intersects(const Node& n) const
	{
		if (maxx < n.minx) return false;
		if (n.maxx < minx) return false;
		if (maxy < n.miny) return false;
		if (n.maxy < miny) return false;
		return true;
	}
};