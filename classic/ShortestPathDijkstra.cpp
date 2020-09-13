// Dijkstra algorithm for finding the shortest path between two vertices
// It should be straightforward to convert to one start, all targets
// Implemented with priority queue, for sparse graph performance
// by ttrkaya
// 02 oct 2015

#include <iostream>
#include <vector>
#include <queue>

namespace dijk{

using namespace std;

const int MAX_VAL = 999999999;

struct Edge{
	int to, weight;
	Edge() {}
	Edge(int to_, int weight_) : to(to_), weight(weight_) {}
	bool operator<(const Edge& o) const { return weight > o.weight; } // for priority queue
};

int n; // number of vertices
vector<vector<Edge>> g; // weighted graph as adjacency list

/// returns path from 0 to n-1
vector<int> getPath(){
	vector<int> from(n, -1);
	vector<int> dists(n, MAX_VAL);
	vector<bool> taken(n);
	priority_queue<Edge> pq;
	from[0] = 0;
	dists[0] = 0;
	pq.push(Edge(0, 0));
	while (!taken[n - 1]){
		int mini = -1;
		while (mini < 0){
			if (pq.empty()) return vector<int>(); // no possible path
			Edge e = pq.top(); pq.pop();
			if (!taken[e.to]){
				mini = e.to;
			}
		}
		taken[mini] = true;
		for (const Edge& e : g[mini]){
			if (dists[mini] + e.weight < dists[e.to]){
				dists[e.to] = dists[mini] + e.weight;
				from[e.to] = mini;
				pq.push(Edge(e.to, dists[e.to]));
			}
		}
	}

	vector<int> res;
	res.push_back(n - 1);
	while (res.back() != 0){
		res.push_back(from[res.back()]);
	}
	reverse(res.begin(), res.end());
	return res;
}

void initG(int newn){
	n = newn;
	g.clear();
	g.resize(n);
}

void addEdge(int from, int to, int w){
	g[from].push_back(Edge(to, w));
	g[to].push_back(Edge(from, w));
}

void test(int testId){
	cout << "Test #" << testId << ": " << endl;
	auto p = getPath();
	for (int i : p) cout << i << " ";
	cout << endl;
}

}

int mainDijk(){
	using namespace dijk;

	int curTestId = 1;

	initG(2);
	addEdge(0, 1, 3);
	test(curTestId++);

	initG(3);
	addEdge(0, 1, 1);
	addEdge(1, 2, 2);
	test(curTestId++);

	initG(3);
	addEdge(0, 1, 1);
	addEdge(1, 2, 2);
	addEdge(0, 2, 5);
	test(curTestId++);

	initG(3);
	addEdge(0, 1, 1);
	addEdge(1, 2, 2);
	addEdge(0, 2, 1);
	test(curTestId++);

	initG(4);
	addEdge(0, 1, 1);
	addEdge(1, 2, 1);
	addEdge(1, 3, 2);
	addEdge(0, 3, 5);
	test(curTestId++);

	return 0;
}