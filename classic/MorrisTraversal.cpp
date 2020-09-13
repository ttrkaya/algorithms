// Morris Traversal algorithm
// In-order tree traversal with linear time and constant memory complexity
// Changes structure of tree in middle steps, but leaves it the same as in the beginning
// by ttrkaya
// 19 oct 2015

#include <iostream>

namespace morris{

	using namespace std;

	struct Node{
		int id;
		Node* left;
		Node* right;

		Node(int id_, Node* left_ = nullptr, Node* right_ = nullptr) : id(id_), left(left_), right(right_){}
	};

	void traverse(Node* root){
		while (root){
			if (!root->left){
				cout << root->id << " ";
				root = root->right;
			}
			else{
				Node* p = root->left;
				while (p->right && p->right != root) p = p->right;
				if (!p->right) {
					p->right = root;
					root = root->left;
				}
				else {
					p->right = nullptr;
					cout << root->id << " ";
					root = root->right;
				}
			}
		}
	}

	void test(int testId, Node* root){
		cout << "Test #" << testId << ":" << endl;
		traverse(root);
		cout << endl;
	}
}

int mainMorris(){
	using namespace morris;

	int curTestId = 1;
	Node* root;

	root = new Node(0);
	test(curTestId++, root);

	root = new Node(0, new Node(1), new Node(2));
	test(curTestId++, root);

	root = new Node(0,
			new Node(1,
				new Node(3)
			),
			new Node(2)
	);
	test(curTestId++, root);

	root = new Node(0,
		new Node(1,
			nullptr,
			new Node(3)
		),
		new Node(2)
	);
	test(curTestId++, root);

	root = new Node(10);
	root->left = new Node(11);
	Node* cur = root;
	for (int i = 0; i < 10; i++){
		cur->right = new Node(i);
		cur = cur->right;
	}
	test(curTestId++, root);

	root = new Node(10);
	root->left = new Node(11);
	cur = root;
	for (int i = 0; i < 10; i++){
		cur->right = new Node(i);
		cur = cur->right;
	}
	cur->left = new Node(20);
	cur->right = new Node(21);
	test(curTestId++, root);

	return 0;
}