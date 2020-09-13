// Eulerian tour and path algorithm for directed graphs
// It should be straightforward to convert this to undirected graph
// by ttrkaya
// 30 sept 2015

#include <iostream>
#include <vector>

namespace euler{

using namespace std;

int n; // number of vertices
vector<vector<int>> g; // directed graph as adjacency list

vector<int> getOutDegrees(){
	vector<int> res(n);
	for (int i = 0; i < n; i++){
		res[i] += g[i].size();
		for (int to : g[i]){
			res[to]--;
		}
	}
	return res;
}

int getNumOddity(){
	vector<int> d = getOutDegrees();
	int res = 0;
	for (int i = 0; i < n; i++){
		res += abs(d[i]);
	}
	return res;
}

vector<bool> visited;
void floodFill(int at){
	if (visited[at]) return;
	visited[at] = true;
	for (int to : g[at]) floodFill(to);
}

int getFirstStart(){
	int start = 0;
	while (start < n && g[start].empty()) start++;
	if (start == n) return -1;
	return start;
}

int getFirstOddStart(){
	vector<int> d = getOutDegrees();
	int start = 0;
	while (start < n && d[start] != 1) start++;
	if (start == n) return -1;
	return start;
}

bool isConnectedForEdgedVertices(){
	int start = getFirstStart();
	if (start < 0) return true; // graph with no edges
	visited.clear();
	visited.resize(n);
	floodFill(start);
	for (int i = 0; i < n; i++){
		if (!visited[i] && !g[i].empty()) return false;
	}
	return true;
}

bool canEulerTour(){
	return isConnectedForEdgedVertices() && getNumOddity() == 0;
}

bool canEulerPath(){
	if (!isConnectedForEdgedVertices()) return false;
	int numOdd = getNumOddity();
	return numOdd == 0 || numOdd == 2;
}

void produceEulerPath(vector<vector<int>>& gCopy, vector<int>& path, int at){
	while (!gCopy[at].empty()){
		int to = gCopy[at].back();
		gCopy[at].pop_back();
		produceEulerPath(gCopy, path, to);
	}
	path.push_back(at);
}

vector<int> getEulerPath(int start){
	vector<vector<int>> gCopy = g;
	vector<int> path;
	produceEulerPath(gCopy, path, start);
	reverse(path.begin(), path.end());
	return path;
}

void test(int testId){
	cout << "Test #" << testId << ":" << endl;
	if (canEulerTour()){
		cout << "Tour: ";
		int start = getFirstStart();
		if (start >= 0){
			auto p = getEulerPath(getFirstStart());
			for (int i : p) cout << i << " ";
		}
	}
	else if (canEulerPath()){
		cout << "Path: ";
		int start = getFirstOddStart();
		if (start >= 0){
			auto p = getEulerPath(getFirstStart());
			for (int i : p) cout << i << " ";
		}
	}
	else{
		cout << "None.";
	}
	cout << endl;
}

}

int mainEuler(){
	using namespace euler;

	int curTestId = 1;

	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(1); g[1].push_back(0);
	test(curTestId++);

	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(1);
	test(curTestId++);

	n = 2;
	g.clear();
	g.resize(n);
	g[0].push_back(1); g[0].push_back(1);
	test(curTestId++);

	n = 1;
	g.clear();
	g.resize(n);
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[1].push_back(2); g[2].push_back(1);
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(1); g[1].push_back(0);
	g[2].push_back(3); g[3].push_back(2);
	test(curTestId++);

	n = 4;
	g.clear();
	g.resize(n);
	g[0].push_back(1); g[1].push_back(0); g[0].push_back(1);
	g[1].push_back(2);
	g[2].push_back(3);
	test(curTestId++);
	
	return 0;
}