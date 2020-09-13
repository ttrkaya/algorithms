// Kosaraju's strongly connected component algorithm for directed graphs
// Runs in O(V + E)
// A strongly connected component is a set of vertices, where each vertex can reach any other vertex via graph
// This algorithm divides vertices into largest scc's possible
// by ttrkaya
// 18 nov 2015

#include <iostream>
#include <vector>

namespace kosaraju{

using namespace std;

int n;
vector<vector<int>> g;
vector<vector<int>> rg;

vector<bool> vis1;
vector<int> s;
void dfs1(int at){
	vis1[at] = true;
	for (int to : g[at]){
		if (!vis1[to]) dfs1(to);
	}
	s.push_back(at);
}

vector<bool> vis2;
vector<vector<int>> scc;
void dfs2(int at){
	vis2[at] = true;
	scc.back().push_back(at);
	for (int to : rg[at]){
		if (!vis2[to]) dfs2(to);
	}
}

vector<vector<int>> getSCC(vector<vector<int>> adjList){
	g.clear();
	rg.clear();
	vis1.clear();
	s.clear();
	vis2.clear();
	scc.clear();

	n = adjList.size();
	g = adjList;

	vis1.resize(n);
	for (int i = 0; i < n; i++){
		if (!vis1[i]) dfs1(i);
	}

	rg.resize(n);
	for (int from = 0; from < n; from++){
		for (int to : g[from]){
			rg[to].push_back(from);
		}
	}
	vis2.resize(n);
	while (!s.empty()){
		int from = s.back(); s.pop_back();
		if (!vis2[from]){
			scc.push_back(vector<int>());
			dfs2(from);
		}
	}

	return scc;
}

void test(vector<vector<int>> graph){
	cout << "g(" << graph.size() << "):" << endl;
	for (int from = 0; from < (int)graph.size(); from++){
		cout << from << ":";
		for (int to : graph[from]){
			cout << " " << to;
		}
		cout << endl;
	}
	auto res = getSCC(graph);
	cout << "stronngly connected components:" << endl;
	for (auto c : res){
		for (int i : c){
			cout << i << " ";
		}
		cout << endl;
	}
	cout << "----------------------" << endl;
}

}

int mainKosaraju(){
	using namespace kosaraju;

	test(vector<vector<int>>{
		{}
	});

	test(vector<vector<int>>{
		{ 1 },
		{ 2 },
		{ 1 }
	});

	test(vector<vector<int>>{
		{ 1 },
		{ 2 },
		{ 0, 3 },
		{ 4 },
		{ 5, 6 },
		{ 3 },
		{ 2 },
		{ 8 },
		{ 9 },
		{ 8 }
	});

	test(vector<vector<int>>{
		{ 1, 2 },
		{ 3 },
		{ 3 },
		{}
	});

	return 0;
}

/*
10
1 2
2 3
3 1
3 4
4 5
5 6
5 7
6 4
7 3
8 9
9 10
10 9

4
1 2 3 4
4
1 2
2 4
1 3
3 4


*/