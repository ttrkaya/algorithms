// Tarjan's strongly connected component algorithm for directed graphs
// Runs in O(V + E)
// A strongly connected component is a set of vertices, where each vertex can reach any other vertex via graph
// This algorithm divides vertices into largest scc's possible
// by ttrkaya
// 18 nov 2015

#include <iostream>
#include <vector>
#include <algorithm>

namespace tarjanscc{

using namespace std;

int n;
vector<vector<int>> g;

int atStep;
vector<int> disc;
vector<int> low;
vector<int> stack;
vector<bool> isOnStack;

vector<vector<int>> scc;
void dfs(int at){
	disc[at] = low[at] = ++atStep;
	stack.push_back(at); isOnStack[at] = true;
	
	for (int to : g[at]){
		if (disc[to] == 0){
			dfs(to);
			low[at] = min(low[at], low[to]);
		}
		else if (isOnStack[to]){
			low[at] = min(low[at], disc[to]);
		}
	}

	if (low[at] == disc[at]){
		scc.push_back(vector<int>());
		while(true){
			int top = stack.back(); stack.pop_back();
			scc.back().push_back(top); isOnStack[top] = false;
			if (top == at) break;
		}
	}
}
	
	
vector<vector<int>> getSCC(vector<vector<int>> adjList){
	atStep = 0;
	disc.clear();
	low.clear();
	isOnStack.clear();
	scc.clear();

	n = adjList.size();
	g = adjList;

	disc.resize(n);
	low.resize(n);
	isOnStack.resize(n);
	for (int i = 0; i < n; i++){
		if (disc[i] == 0) dfs(i);
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

int main(){
	using namespace tarjanscc;

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