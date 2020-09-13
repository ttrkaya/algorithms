// A* algorithm for finding the shortest path between two vertices
// Implemented with priority queue
// by ttrkaya
// 02 oct 2015

#include <iostream>
#include <vector>
#include <queue>
#include <random>

namespace astar{

using namespace std;

struct P{
	int y, x, f;
	P() {};
	P(int y_, int x_, int f_) : y(y_), x(x_), f(f_) {};
	bool operator<(const P& o) const { return f > o.f; } // for priority queue
};

const int MAX_VAL = 999999999;
const int OBSTACLE = -1;
const int FREE = 0;
const int ON_PATH = 1;
const int MAX_H = 1000;
const int MAX_W = 1000;

int h, w;
int m[MAX_H][MAX_W];

int getf(int y, int x, int dist) { return dist + abs(h - 1 - y) + abs(w - 1 - x); }

// edge connectivity
int dy[] {0, 0, 1, -1};
int dx[] {1, -1, 0, 0};

int dists[MAX_H][MAX_W];
bool taken[MAX_H][MAX_W];
/// marks path from [0, 0] to [n-1, n-1]
void calcPath(){
	for (int y = 0; y < h; y++){
		for (int x = 0; x < w; x++){
			dists[y][x] = MAX_VAL;
			taken[y][x] = (m[y][x] == OBSTACLE);
		}
	}
	priority_queue<P> pq;
	dists[0][0] = 0;
	pq.push(P(0, 0, getf(0, 0, 0)));
	while (!taken[h - 1][w - 1]){
		int fromy = -1, fromx = -1;
		while (fromy < 0){
			if (pq.empty()) return; // no possible path
			P p = pq.top(); pq.pop();
			if (!taken[p.y][p.x]){
				fromy = p.y; fromx = p.x;
			}
		}
		taken[fromy][fromx] = true;
		for (int i = 0; i < 4; i++){
			int toy = fromy + dy[i];
			int tox = fromx + dx[i];
			if (toy < 0 || toy >= h || tox < 0 || tox >= w) continue;
			if (taken[toy][tox]) continue;
			if (dists[fromy][fromx] + 1 < dists[toy][tox]){
				dists[toy][tox] = dists[fromy][fromx] + 1;
				pq.push(P(toy, tox, getf(toy, tox, dists[toy][tox])));
			}
		}
	}

	int aty = h - 1;
	int atx = w - 1;
	m[aty][atx] = ON_PATH;
	while (!(aty == 0 && atx == 0)){
		for (int i = 0; i < 4; i++){
			int toy = aty + dy[i];
			int tox = atx + dx[i];
			if (toy < 0 || toy >= h || tox < 0 || tox >= w) continue;
			if (dists[toy][tox] != dists[aty][atx] - 1) continue;
			aty = toy;
			atx = tox;
			break;
		}
		m[aty][atx] = ON_PATH;
	}
}

}

int mainAStar(){
	using namespace astar;

	srand(1);
	for (int t = 1; t <= 20; t++){
		cout << "Test #" << t << ":" << endl;
		h = 1 + rand() % 20;
		w = 1 + rand() % 20;
		for (int y = 0; y < h; y++){
			for (int x = 0; x < w; x++){
				m[y][x] = (rand() < RAND_MAX / 5 ? OBSTACLE : FREE);
			}
		}
		m[0][0] = m[h - 1][w - 1] = FREE;
		calcPath();
		for (int y = 0; y < h; y++){
			for (int x = 0; x < w; x++){
				switch (m[y][x])
				{
				case OBSTACLE:{
					cout << '#';
				}break;
				case FREE:{
					cout << '.';
				}break;
				case ON_PATH:{
					cout << 'o';
				}break;
				}
			}
			cout << endl;
		}
		cout << endl;
	}

	return 0;
}