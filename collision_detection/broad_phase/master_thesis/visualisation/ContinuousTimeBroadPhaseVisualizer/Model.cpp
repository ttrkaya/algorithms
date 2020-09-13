#include "Model.h"

void Model::init(string filename)
{
	std::ifstream fin(filename);
	
	int stageWidth, stageHeight;
	fin >> stageWidth >> stageHeight >> timeTill;

	fin >> numLines;
	linexs.resize(numLines * 2);
	lineys.resize(numLines * 2);
	for (int i = 0; i < numLines; i++)
	{
		fin >> linexs[i * 2] >> lineys[i * 2] >> linexs[i * 2 + 1] >> lineys[i * 2 + 1];
	}

	fin >> numCircles;
	rs.resize(numCircles);
	for (int i = 0; i < numCircles; i++)
	{
		fin >> rs[i];
	}

	int numTimes;
	fin >> numTimes;
	times.resize(numTimes);
	cx.resize(numTimes, reals(numCircles));
	cy.resize(numTimes, reals(numCircles));

	int atPerc = -1;
	for (int t = 0; t < numTimes; t++)
	{
		fin >> times[t];
		for (int i = 0; i < numCircles; i++)
		{
			fin >> cx[t][i] >> cy[t][i];
		}
		int perc = 100 * t / numTimes;
		if (perc > atPerc)
		{
			atPerc = perc;
			cout << "Pos read %" << atPerc << endl;
		}
	}
	cout << "Pos read finished" << endl;

	int numaabbs;
	fin >> numaabbs;
	int waabbs = 2 * (numCircles + numLines);
	aabbs.resize(numaabbs, vector<AABB>(waabbs));
	atPerc = -1;
	for (int i = 0; i < numaabbs; i++)
	{
		for (int j = 0; j < waabbs; j++)
		{
			auto& a = aabbs[i][j];
			fin >> a.minx >> a.miny >> a.maxx >> a.maxy;
		}
		int perc = 100 * i / numaabbs;
		if (perc > atPerc)
		{
			atPerc = perc;
			cout << "AABB read %" << atPerc << endl;
		}
	}
	cout << "AABB read finished" << endl;

	timeIndex = 0;
	progress(0);
}

void Model::reset()
{
	time = 0;
	timeIndex = 0;
	progress(0);
}

void Model::progress(real dt)
{
	time += dt;
	while (timeIndex < times.size() - 1 && time > times[timeIndex + 1])
	{
		timeIndex++;
	}
	if (timeIndex == times.size() - 1)
	{
		timeIndex = times.size() - 2;
		timeFactor0 = 0;
		timeFactor1 = 1;
	}
	else
	{
		real span = times[timeIndex + 1] - times[timeIndex];
		timeFactor1 = (time - times[timeIndex]) / span;
		timeFactor0 = 1.0 - timeFactor1;
	}
}

bool Model::finished()
{
	return time >= timeTill;
}

real Model::getx(int i) const
{
	return timeFactor0 * cx[timeIndex][i] + timeFactor1 * cx[timeIndex + 1][i];
}

real Model::gety(int i) const
{
	return timeFactor0 * cy[timeIndex][i] + timeFactor1 * cy[timeIndex + 1][i];
}

const Model::AABB& Model::getaabb(int i) const
{
	static Model::AABB err;
	err.minx = err.maxx = err.miny = err.maxy = 1;
	if (i >= aabbs.front().size()) return err;
	return aabbs[timeIndex][i];
}