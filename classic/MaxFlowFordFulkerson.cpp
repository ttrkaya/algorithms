// Ford Fulkerson algorithm for max flow
// by ttrkaya
// 01 oct 2015

#include <iostream>
#include <vector>
#include <algorithm>

namespace ford{

using namespace std;

struct Edge{
	int to, weight;
	Edge() {}
	Edge(int to_, int weight_) : to(to_), weight(weight_) {}
};

int n; // number of vertices
vector<vector<Edge>> g; // directed weighted graph as adjacency list

int visitId;
vector<int> visited;
vector<int> path;
bool dfs(int at){
	if (visited[at] == visitId) return false;
	visited[at] = visitId;

	path.push_back(at);
	if (at == n - 1) return true; 

	for (const Edge& e : g[at]){
		if(dfs(e.to)) return true;
	}

	path.pop_back();
	return false;
}

int getEdgeWeight(int from, int to){
	for (const Edge& e : g[from]){
		if (e.to == to) return e.weight;
	}
	return 0;
}

void addEdgeWeight(int from, int to, int add){
	for (Edge& e : g[from]){
		if (e.to == to){
			e.weight += add;
			return;
		}
	}
	g[from].push_back(Edge(to, add));
}

void decEdgeWeight(int from, int to, int dec){
	for (int i = (int)g[from].size() - 1; i >= 0; i--){
		Edge& e = g[from][i];
		if (e.to == to){
			e.weight -= dec;
			if (e.weight == 0){
				g[from][i] = g[from].back();
				g[from].pop_back();
			}
			return;
		}
	}
}

// assumes souce = 0; sink = n - 1;
int getMaxFlow(){
	int res = 0;
	visitId++;
	visited.resize(n);
	path.clear();
	while (dfs(0)){
		int l = (int)path.size();
		int cur = getEdgeWeight(path[l - 2], path[l - 1]);
		for (int i = l - 3; i >= 0; i--){
			cur = min(cur, getEdgeWeight(path[i], path[i + 1]));
		}
		for (int i = (int)path.size() - 2; i >= 0; i--){
			decEdgeWeight(path[i], path[i + 1], cur);
			addEdgeWeight(path[i + 1], path[i], cur);
		}
		res += cur;

		visitId++;
		path.clear();
	}
	return res;
}

void test(int testId){
	cout << "Test #" << testId << ": " << getMaxFlow() << endl;
}

}

int mainFord(){
	using namespace ford;

	int curTestId = 1;
	
	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 3));
	test(curTestId++);

	n = 3;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 3));
	g[1].push_back(Edge(2, 4));
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1));
	g[0].push_back(Edge(2, 5));
	g[1].push_back(Edge(3, 3));
	g[2].push_back(Edge(3, 2));
	test(curTestId++);

	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 3));
	g[1].push_back(Edge(0, 3));
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1));
	g[0].push_back(Edge(2, 5));
	g[1].push_back(Edge(3, 3));
	g[2].push_back(Edge(3, 2));
	g[1].push_back(Edge(2, 9));
	test(curTestId++);

	n = 2;
	g.clear();
	g.resize(n);
	test(curTestId++);

	n = 5;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1));
	g[0].push_back(Edge(2, 5));
	g[1].push_back(Edge(3, 3));
	g[2].push_back(Edge(3, 2));
	g[1].push_back(Edge(2, 9));
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(Edge(1, 1));
	g[2].push_back(Edge(3, 1));
	test(curTestId++);


	return 0;
}