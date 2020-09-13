// Kruskal algorithm for constructing minimum spanning tree
// Greedily inserts new edges
// by ttrkaya
// 02 oct 2015

#include <iostream>
#include <vector>
#include <algorithm>

namespace kruskal{

using namespace std;

struct Edge{
	int from, to, weight;
	Edge() {}
	Edge(int from_, int to_, int weight_) : from(from_), to(to_), weight(weight_) {}
	bool operator<(const Edge& o) const { return weight < o.weight; } // for priority queue
};

int n; // number of vertices
vector<Edge> g; // weighted graph as adgge list

vector<int> dsu;
int find(int x) { return x == dsu[x] ? x : dsu[x] = find(dsu[x]); }
void join(int x, int y) { dsu[find(x)] = find(y); }

vector<Edge> getMinimumSpanningTree(){
	vector<Edge> res = g; // the resulting spanning tree as an edge list graph
	sort(res.begin(), res.end());
	dsu.resize(n);
	for (int i = 0; i < n; i++) dsu[i] = i;
	int at = 0;
	for (int i = 0; i < res.size(); i++){
		const Edge& e = res[i];
		if (find(e.from) != find(e.to)){
			res[at++] = e;
			if (at == n - 1) break;
			join(e.from, e.to);
		}
	}
	res.resize(at);
	return res;
}

void test(int testId){
	auto mst = getMinimumSpanningTree();
	cout << "Test #" << testId << ":" << endl;
	for (Edge e : mst){
		cout << e.from << " -> " << e.to << " w " << e.weight << endl;
	}
}

}

int mainKrusk(){
	using namespace kruskal;

	int curTestId = 1;

	n = 2;
	g.clear();
	g.push_back(Edge(0, 1, 3));
	test(curTestId++);

	n = 3;
	g.clear();
	g.push_back(Edge(0, 1, 1));
	g.push_back(Edge(1, 2, 2));
	g.push_back(Edge(0, 2, 3));
	test(curTestId++);

	n = 4;
	g.clear();
	g.push_back(Edge(0, 1, 1));
	g.push_back(Edge(1, 2, 2));
	g.push_back(Edge(0, 2, 3));
	g.push_back(Edge(3, 0, 6));
	g.push_back(Edge(3, 1, 5));
	g.push_back(Edge(3, 2, 7));
	test(curTestId++);

	return 0;
}