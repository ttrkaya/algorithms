// Prim algorithm for constructing minimum spanning tree
// Greedily inserts new vertices
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <vector>
#include <queue>

namespace prim{

using namespace std;

struct Edge{
	int to, weight;
	Edge() {}
	Edge(int to_, int weight_) : to(to_), weight(weight_) {}
	bool operator<(const Edge& o) const { return weight > o.weight; } // for priority queue
};

int n; // number of vertices
vector<vector<Edge>> g; // weighted graph as adjacency list

vector<vector<Edge>> getMinimumSpanningTree(){
	vector<vector<Edge>> res(n); // the resulting spanning tree as an adjecancy list graph
	vector<Edge> cand(n, Edge(n, 0)); // best candidate edge for including the i`th vertex
	cand[0].to = -1; // means already added; n would mean no candidate edge yet
	priority_queue<Edge> pq;
	for (const Edge& e : g[0]){
		cand[e.to].to = 0;
		cand[e.to].weight = e.weight;
		pq.push(e);
	}
	for (int toAdd = n - 1; toAdd > 0; toAdd--){
		int minCostIndex = -1;
		while (minCostIndex < 0){
			Edge e = pq.top(); pq.pop();
			if (cand[e.to].to >= 0){
				minCostIndex = e.to;
			}
		}
		res[minCostIndex].push_back(cand[minCostIndex]);
		cand[minCostIndex].to = -1;
		for (const Edge& e : g[minCostIndex]){
			if (cand[e.to].to == n || e.weight < cand[e.to].weight){
				cand[e.to].to = minCostIndex;
				cand[e.to].weight = e.weight;
				pq.push(e);
			}
		}
	}
	return res;
}

void test(int testId){
	auto mst = getMinimumSpanningTree();
	cout << "Test #" << testId << ":" << endl;
	for (int i = 0; i < n; i++){
		for (Edge e : mst[i]){
			cout << i << " -> " << e.to << " w " << e.weight << endl;
		}
	}
}

}

int mainPrim(){
	using namespace prim;

	int curTestId = 1;

	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 3)); g[1].push_back(Edge(0, 3));
	test(curTestId++);

	n = 3;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1)); g[1].push_back(Edge(0, 1));
	g[1].push_back(Edge(2, 2)); g[2].push_back(Edge(1, 2));
	g[0].push_back(Edge(2, 3)); g[2].push_back(Edge(0, 3));
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1)); g[1].push_back(Edge(0, 1));
	g[1].push_back(Edge(2, 2)); g[2].push_back(Edge(1, 2));
	g[0].push_back(Edge(2, 3)); g[2].push_back(Edge(0, 3));
	g[3].push_back(Edge(0, 6)); g[0].push_back(Edge(3, 6));
	g[3].push_back(Edge(1, 5)); g[1].push_back(Edge(3, 5));
	g[3].push_back(Edge(2, 7)); g[2].push_back(Edge(3, 7));
	test(curTestId++);

	return 0;
}