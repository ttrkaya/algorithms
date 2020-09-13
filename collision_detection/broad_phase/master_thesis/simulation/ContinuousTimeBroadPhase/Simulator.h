#pragma once

#include <vector>
#include <algorithm>

#include "Constants.h"
#include "Utils.h"
#include "Vec2.h"
#include "Circle.h"
#include "Line.h"
#include "Node.h"

using std::min;
using std::max;

typedef std::vector<Circle> Circles;
typedef std::vector<Line> Lines;
typedef std::vector<Node> Tree;

class Simulator
{
public:
	Circles circles;
	Lines lines;
	real time;

	real treeStep;
	Tree tree;
	real treeColTime;
	int treeColCircleIndex;
	int treeColOtherCircleIndex;
	int treeColLineIndex;

	Simulator();
	
	int init(real w, real h, int numCircles, real minr, real maxr);
	void updateBrute();
	void updateBVH();
private:
	bool collidesWithAnyCircle(const Circle& c);

	void updateTree(bool rebuild);
	void divideSort(int begin, int end, bool sortOnX);

	void checkColOfNode(int at);
	void checkColOfNodePair(int nodeIndex0, int nodeIndex1);

	void resolve(real dt, int colCircleIndex, int colOtherCircleIndex, int colLineIndex);
};

