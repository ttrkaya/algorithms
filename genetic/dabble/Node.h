#pragma once

#include <string>
#include <cmath>
#include <random>
#include <algorithm>

class Node
{
private:
	enum class Type
	{
		TERMINAL,
		FUNCTION
	};
	enum class TerminalType
	{
		VARIABLE,
		CONSTANT
	};
	enum class FunctionType
	{
		ADD,
		SUBSTRACT,
		MULTIPLY,
		DIVIDE
	};

	Type type;
	union
	{
		TerminalType terminalType;
		FunctionType functionType;
	} subType;

	union
	{
		struct
		{
			Node* child0;
			Node* child1;
		} children;
		double value;
	} data;

public:
	Node();
	Node(const Node& node);
	~Node();

	void operator=(const Node& node);

	void generate(int curDepthAllowed);

	double evaluate(double x) const;

	void mutate();
	void setAsChildOf(const Node& p0, const Node& p1);

	int getDepth() const;

	std::string getString();

private:
	Node getRandomBrach() const;
};

