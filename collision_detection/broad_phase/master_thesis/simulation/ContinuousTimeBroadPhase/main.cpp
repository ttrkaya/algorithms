#include <iostream>
#include <fstream>
#include <iomanip>
#include <ctime>
#include <chrono>

#include "Simulator.h"

using std::cout;
using std::endl;

real getSimulationDuration(int sw, int sh, int nc, real cminr, real cmaxr, real simTime, bool bvh){
	using std::chrono::duration;
	using std::chrono::duration_cast;
	using std::chrono::high_resolution_clock;
	typedef std::chrono::high_resolution_clock::time_point TimePoint;

	Simulator sim; int simInitSuccess = sim.init(sw, sh, nc, cminr, cmaxr);
	if (simInitSuccess != 0) return -1;
	TimePoint startTime = high_resolution_clock::now();
	while (sim.time <= simTime){
		if (bvh) {
			sim.updateBVH();
		}
		else {
			sim.updateBrute();
		}
	}
	TimePoint endTime = high_resolution_clock::now();
	duration<double> dur = duration_cast<duration<double>>(endTime - startTime);
	return dur.count();
}

void produceVisualization(){
	std::ofstream fout("simvis.txt");
	std::ios_base::sync_with_stdio(false);
	fout.tie(0);

	const int RANDOM = 1;
	Utils::init(RANDOM > 0 ? RANDOM : (int)time(NULL));

	const int STAGE_WIDTH = 800;
	const int STAGE_HEIGHT = 600;
	const int NUM_LINES = 4;
	const int NUM_CIRC = (1 << 5) - NUM_LINES;
	const real CIRCLE_MIN_R = 2;
	const real CIRCLE_MAX_R = 5;
	Simulator sim;
	int simInitSuccess = sim.init(STAGE_WIDTH, STAGE_HEIGHT, NUM_CIRC, CIRCLE_MIN_R, CIRCLE_MAX_R);
	if (simInitSuccess != 0)
	{
		fout << "Sim init unseccessful with code: " << simInitSuccess << endl;
		return;
	}

	const bool BVH = true;

	std::vector<std::vector<Node>> aabbs;

	const real TIME_TILL = 5;
	std::vector<real> posTimes{ 0 };
	std::vector<std::vector<Vec2>> poses(1);
	std::vector<Vec2>& initposes = poses.back();
	initposes.resize(sim.circles.size());
	for (int i = NUM_CIRC - 1; i >= 0; i--)
	{
		initposes[i] = sim.circles[i].pos;
	}
	while (sim.time <= TIME_TILL)
	{
		if (BVH)
		{
			sim.updateBVH();
		}
		else
		{
			sim.updateBrute();
		}

		posTimes.push_back(sim.time);
		poses.resize(poses.size() + 1);
		std::vector<Vec2>& newPoses = poses.back();
		newPoses.resize(sim.circles.size());
		for (int i = NUM_CIRC - 1; i >= 0; i--)
		{
			newPoses[i] = sim.circles[i].pos;
		}

		if (BVH)
		{
			aabbs.push_back(sim.tree);
		}
	}

	fout << std::fixed << std::setprecision(9);
	fout << STAGE_WIDTH << " " << STAGE_HEIGHT << " " << TIME_TILL << endl;
	fout << sim.lines.size() << endl;
	for (const Line& l : sim.lines)
	{
		fout << l.a.x << " " << l.a.y << " " << l.b.x << " " << l.b.y << endl;
	}
	fout << NUM_CIRC << endl;
	for (const Circle& c : sim.circles)
	{
		fout << c.r << endl;
	}
	int numPoses = poses.size();
	fout << numPoses << endl;
	for (int i = 0; i < numPoses; i++)
	{
		fout << posTimes[i] << endl;
		for (const Vec2& v : poses[i])
		{
			fout << v.x << " " << v.y << " ";
		}
		fout << endl;
	}

	fout << aabbs.size() << endl;
	for (auto v : aabbs)
	{
		for (Node n : v)
		{
			fout << n.minx << " " << n.miny << " " << n.maxx << " " << n.maxy << " ";
		}
		fout << endl;
	}
}

int main() {
	Utils::init(0);

	const int NUM_LINES = 4;
	const real CIRCLE_MIN_R = 2;
	const real CIRCLE_MAX_R = 5;
	const real STAGE_WIDTH = CIRCLE_MAX_R * 5;
	const real STAGE_HEIGHT = CIRCLE_MAX_R * 3;
	const real SIM_TIME = 5;

	//produceVisualization();
	//return 0;

	cout << std::fixed << std::setprecision(9);
	for (int i = 3; i <= 20; i++){
		int numCircles = (1 << i) - NUM_LINES;
		real sizeFactor = sqrt((real)numCircles);
		real sw = STAGE_WIDTH * sizeFactor;
		real sh = STAGE_HEIGHT * sizeFactor;
		real durationSlow = getSimulationDuration(sw, sh, numCircles, CIRCLE_MIN_R, CIRCLE_MAX_R, SIM_TIME, false);
		real durationFast = getSimulationDuration(sw, sh, numCircles, CIRCLE_MIN_R, CIRCLE_MAX_R, SIM_TIME, true);
		cout << numCircles << ":\t" << durationSlow << " : " << durationFast << endl;
	}

	cout << "fin" << endl;
	getchar();

	return 0;
}