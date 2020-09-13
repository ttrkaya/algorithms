#include "Simulator.h"


Simulator::Simulator()
{
}

int Simulator::init(real w, real h, int numCircles, real minr, real maxr)
{
	lines.clear();
	lines.push_back(Line(0, 0, w, 0));
	lines.push_back(Line(0, h, w, h));
	lines.push_back(Line(0, 0, 0, h));
	lines.push_back(Line(w, 0, w, h));

	circles.clear();
	for (int i = 0; i < numCircles; i++)
	{
		Circle c;
		c.r = minr + Utils::getRandom() * (maxr - minr);
		int numTries = 0;
		const int MAX_TRIES = 100;
		for (;numTries < MAX_TRIES; numTries++)
		{
			c.pos.x = c.r + Utils::getRandom() * (w - 2 * c.r);
			c.pos.y = c.r + Utils::getRandom() * (h - 2 * c.r);
			if (!collidesWithAnyCircle(c)) break;
		}
		if (numTries >= MAX_TRIES) return 1;
		c.vel.x = w * 2 * (Utils::getRandom() - 0.5);
		c.vel.y = h * 2 * (Utils::getRandom() - 0.5);
		circles.push_back(c);
	}

	//needs to be a power of two
	int numLines = lines.size();
	int numBodies = numCircles + numLines;
	int pow = 1;
	while (pow < numBodies) pow *= 2;
	if (pow != numBodies)
	{
		return 2;
	}
	treeStep = 1;
	tree.resize(numBodies * 2, Node{-1, INF, INF, INF, INF});
	for (int i = 0; i < numCircles; i++)
	{
		Node& node = tree[numBodies + i];
		node.bodyIndex = i;
	}
	for (int i = 0; i < numLines; i++)
	{
		Node& node = tree[numBodies + numCircles + i];
		const Line& line = lines[i];
		node.bodyIndex = numCircles + i;
		node.minx = min(line.a.x, line.b.x);
		node.miny = min(line.a.y, line.b.y);
		node.maxx = max(line.a.x, line.b.x);
		node.maxy = max(line.a.y, line.b.y);
	}

	return 0;
}

void Simulator::updateTree(bool rebuild)
{
	int numCircles = circles.size();
	int numLines = lines.size();
	int numBodies = numCircles + numLines;
	for (int i = 0; i < numBodies; i++)
	{
		Node& node = tree[numBodies + i];
		if (node.bodyIndex >= numCircles) continue;
		const Circle& circle = circles[node.bodyIndex];
		node.minx = circle.pos.x - circle.r;
		node.maxx = circle.pos.x + circle.r;
		if (circle.vel.x > 0)
		{
			node.maxx += circle.vel.x * treeStep;
		}
		else
		{
			node.minx += circle.vel.x * treeStep;
		}
		node.miny = circle.pos.y - circle.r;
		node.maxy = circle.pos.y + circle.r;
		if (circle.vel.y > 0)
		{
			node.maxy += circle.vel.y * treeStep;
		}
		else
		{
			node.miny += circle.vel.y * treeStep;
		}
	}
	if (rebuild)
	{
		divideSort(numBodies, 2 * numBodies, true);
	}
	for (int i = numBodies - 1; i >= 1; i--)
	{
		Node& parent = tree[i];
		const Node& child0 = tree[2 * i];
		const Node& child1 = tree[2 * i + 1];
		parent.minx = min(child0.minx, child1.minx);
		parent.miny = min(child0.miny, child1.miny);
		parent.maxx = max(child0.maxx, child1.maxx);
		parent.maxy = max(child0.maxy, child1.maxy);
	}
}

bool sortHelperX(const Node& n0, const Node& n1) { return n0.minx + n0.maxx < n1.minx + n1.maxx; }
bool sortHelperY(const Node& n0, const Node& n1) { return n0.miny + n0.maxy < n1.miny + n1.maxy; }

void Simulator::divideSort(int begin, int end, bool sortOnX)
{
	if (begin + 1 == end) return;
	
	//sort(tree.begin() + begin, tree.begin() + end, sortOnX ? sortHelperX : sortHelperY);
	int middle = (begin + end) / 2;
	std::nth_element(tree.begin() + begin, tree.begin() + middle, tree.begin() + end, sortOnX ? sortHelperX : sortHelperY);

	divideSort(begin, middle, !sortOnX);
	divideSort(middle, end, !sortOnX);
}

bool Simulator::collidesWithAnyCircle(const Circle& c)
{
	for (const Circle& o : circles)
	{
		if (c.doesCollide(o)) return true;
	}
	return false;
}

void Simulator::updateBrute()
{
	real colTime = INF;
	int colCircleIndex = -1;
	int colOtherCircleIndex = -1;
	int colLineIndex = -1;

	int numCircles = (int)circles.size();
	for (int i = 0; i < numCircles; i++)
	{
		const Circle& circle = circles[i];
		for (int j = i + 1; j < numCircles; j++)
		{
			const Circle& otherCircle = circles[j];
			real t = circle.getColTime(otherCircle);
			if (t >= 0 && t < colTime)
			{
				colTime = t;
				colCircleIndex = i;
				colOtherCircleIndex = j;
			}
		}
	}

	int numLines = (int)lines.size();
	for (int i = 0; i < numCircles; i++)
	{
		const Circle& circle = circles[i];
		for (int j = 0; j < numLines; j++)
		{
			const Line& line = lines[j];
			real t = circle.getColTime(line);
			if (t >= 0 && t < colTime)
			{
				colTime = t;
				colCircleIndex = i;
				colLineIndex = j;
				colOtherCircleIndex = -1;
			}
		}
	}

	resolve(colTime, colCircleIndex, colOtherCircleIndex, colLineIndex);
}

void Simulator::updateBVH()
{
	treeColTime = -1;
	bool rebuild = true;
	treeStep *= 0.25;
	while (treeColTime < 0)
	{
		treeStep *= 2;
		updateTree(rebuild);
		rebuild = false;
		checkColOfNode(1);
	}

	resolve(treeColTime, treeColCircleIndex, treeColOtherCircleIndex, treeColLineIndex);
}

void Simulator::checkColOfNode(int at)
{
	if (tree[at].bodyIndex >= 0) return;
	int child0 = 2 * at;
	int child1 = 2 * at + 1;
	checkColOfNodePair(child0, child1);
	checkColOfNode(child0);
	checkColOfNode(child1);
}

void Simulator::checkColOfNodePair(int nodeIndex0, int nodeIndex1)
{
	const Node& node0 = tree[nodeIndex0];
	const Node& node1 = tree[nodeIndex1];
	if (!node0.intersects(node1)) return;

	int numCircles = circles.size();
	if (node0.bodyIndex >= 0 && node1.bodyIndex >= 0)
	{
		if (node0.bodyIndex >= numCircles && node1.bodyIndex >= numCircles) return;

		int minBodyIndex, maxBodyIndex;
		if (node0.bodyIndex < node1.bodyIndex)
		{
			minBodyIndex = node0.bodyIndex;
			maxBodyIndex = node1.bodyIndex;
		}
		else
		{
			minBodyIndex = node1.bodyIndex;
			maxBodyIndex = node0.bodyIndex;
		}
		if (maxBodyIndex >= numCircles)
		{
			int lineIndex = maxBodyIndex - numCircles;
			real colTime = circles[minBodyIndex].getColTime(lines[lineIndex]);
			if (colTime >= 0 && colTime < treeStep && (treeColTime < 0 || colTime < treeColTime))
			{
				treeColTime = colTime;
				treeColCircleIndex = minBodyIndex;
				treeColOtherCircleIndex = -1;
				treeColLineIndex = lineIndex;
			}
		}
		else
		{
			real colTime = circles[minBodyIndex].getColTime(circles[maxBodyIndex]);
			if (colTime >= 0 && colTime < treeStep && (treeColTime < 0 || colTime < treeColTime))
			{
				treeColTime = colTime;
				treeColCircleIndex = minBodyIndex;
				treeColOtherCircleIndex = maxBodyIndex;
				treeColLineIndex = -1;
			}
		}
		return;
	}

	if (node1.bodyIndex >= 0)
	{
		checkColOfNodePair(nodeIndex1, nodeIndex0 * 2);
		checkColOfNodePair(nodeIndex1, nodeIndex0 * 2 + 1);
	}
	else if (node0.bodyIndex >= 0)
	{
		checkColOfNodePair(nodeIndex0, nodeIndex1 * 2);
		checkColOfNodePair(nodeIndex0, nodeIndex1 * 2 + 1);
	}
	else if ((node0.maxx - node0.minx) * (node0.maxy - node0.miny) > (node1.maxx - node1.minx) * (node1.maxy - node1.miny))
	{
		checkColOfNodePair(nodeIndex1, nodeIndex0 * 2);
		checkColOfNodePair(nodeIndex1, nodeIndex0 * 2 + 1);
	}
	else
	{
		checkColOfNodePair(nodeIndex0, nodeIndex1 * 2);
		checkColOfNodePair(nodeIndex0, nodeIndex1 * 2 + 1);
	}
}


void Simulator::resolve(real dt, int colCircleIndex, int colOtherCircleIndex, int colLineIndex)
{
	time += dt;
	for (Circle& c : circles)
	{
		c.pos += c.vel * dt;
	}

	if (colLineIndex >= 0)
	{
		circles[colCircleIndex].collide(lines[colLineIndex]);
	}
	else if (colOtherCircleIndex >= 0)
	{
		circles[colCircleIndex].collide(circles[colOtherCircleIndex]);
	}
}