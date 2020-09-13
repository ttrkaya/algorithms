#pragma once

#include <string>
#include <fstream>
#include <iostream>
#include <vector>

#include "Constants.h"

using std::vector;
using std::string;
using std::cout;
using std::endl;

typedef vector<real> reals;
typedef vector<reals> realss;

class Model
{
public:
	class AABB
	{
	public:
		real minx, miny, maxx, maxy;
	};

	int numLines;
	reals linexs;
	reals lineys;

	int numCircles;
	reals rs;
	reals times;
	realss cx;
	realss cy;

	vector<vector<Model::AABB>> aabbs;

	real timeTill;
	real time;
	int timeIndex;
	real timeFactor0;
	real timeFactor1;

	Model() {};
	void init(string filename);

	void progress(real dt);
	bool finished();
	void reset();
	real getx(int i) const;
	real gety(int i) const;

	const AABB& getaabb(int i) const;
};

