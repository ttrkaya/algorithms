#include "Node.h"

#include <assert.h>

Node::Node() : type(Type::TERMINAL)
{
	
}

Node::Node(const Node& node)
{
	*this = node;
}

Node::~Node()
{
	if (type == Type::FUNCTION)
	{
		delete data.children.child0;
		delete data.children.child1;
	}
}

void Node::operator=(const Node& node)
{
	if (node.type == Type::TERMINAL)
	{
		type = Type::TERMINAL;
		if (node.subType.terminalType == TerminalType::VARIABLE)
		{
			subType.terminalType = TerminalType::VARIABLE;
		}
		else
		{
			subType.terminalType = TerminalType::CONSTANT;
			data.value = node.data.value;
		}
	}
	else
	{
		type = Type::FUNCTION;
		subType.functionType = node.subType.functionType;
		data.children.child0 = new Node();
		*data.children.child0 = *node.data.children.child0;
		data.children.child1 = new Node();
		*data.children.child1 = *node.data.children.child1;
	}
}

void Node::generate(int curDepthAllowed)
{
	if (type == Type::FUNCTION)
	{
		delete data.children.child0;
		delete data.children.child1;
	}

	double r = double(std::rand()) / RAND_MAX;

	if (curDepthAllowed == 0)
	{
		type = Type::TERMINAL;		

		if (r < 0.3)
		{
			subType.terminalType = TerminalType::CONSTANT;
			data.value = double(std::rand()) / RAND_MAX;
			data.value -= 0.5;
			data.value *= 2;
			data.value *= 5; // range
		}
		else
		{
			subType.terminalType = TerminalType::VARIABLE;
		}
	}
	else
	{
		type = Type::FUNCTION;

		if (r < 0.25)		subType.functionType = FunctionType::ADD;
		else if (r < 0.50)	subType.functionType = FunctionType::SUBSTRACT;
		else if (r < 0.75)	subType.functionType = FunctionType::MULTIPLY;
		else				subType.functionType = FunctionType::DIVIDE;

		data.children.child0 = new Node();
		data.children.child0->generate(curDepthAllowed - 1);
		data.children.child1 = new Node();
		data.children.child1->generate(curDepthAllowed - 1);
	}
}

double Node::evaluate(double x) const
{
	if (type == Type::TERMINAL)
	{
		if (subType.terminalType == TerminalType::CONSTANT) return data.value;
		else return x;
	}
	else
	{
		switch (subType.functionType)
		{
		case FunctionType::ADD:			return data.children.child0->evaluate(x) + data.children.child1->evaluate(x);
		case FunctionType::SUBSTRACT:	return data.children.child0->evaluate(x) - data.children.child1->evaluate(x);
		case FunctionType::MULTIPLY:	return data.children.child0->evaluate(x) * data.children.child1->evaluate(x);
		case FunctionType::DIVIDE:		
			double divider = data.children.child1->evaluate(x);
			if(divider == 0.0) return 1.0;
			else return data.children.child0->evaluate(x) / divider;
		}
	}

	assert(false);
	return -1;
}

void Node::mutate()
{
	if (type == Type::FUNCTION)
	{
		data.children.child0->mutate();
		data.children.child1->mutate();
	}

	double r = double(std::rand()) / RAND_MAX;

	if (r < 0.1)
	{
		if (type == Type::FUNCTION)
		{
			r = double(std::rand()) / RAND_MAX;
			if (r < 0.25)		subType.functionType = FunctionType::ADD;
			else if (r < 0.50)	subType.functionType = FunctionType::SUBSTRACT;
			else if (r < 0.75)	subType.functionType = FunctionType::MULTIPLY;
			else				subType.functionType = FunctionType::DIVIDE;
		}
		else
		{
			if (subType.terminalType == TerminalType::VARIABLE)
			{
				r = double(std::rand()) / RAND_MAX;
				if (r < 0.5)
				{
					subType.terminalType = TerminalType::CONSTANT;
					data.value = double(std::rand()) / RAND_MAX;
					data.value -= 0.5;
					data.value *= 2;
					data.value *= 5; // range
				}
			}
			else
			{
				r = double(std::rand()) / RAND_MAX;
				if (r < 0.1)
				{
					subType.terminalType = TerminalType::VARIABLE;
				}
				else
				{
					r = double(std::rand()) / RAND_MAX;
					if (r < 0.5)
					{
						r = double(std::rand()) / RAND_MAX;
						r -= 0.5;
						data.value += r;
					}
					else
					{
						r = double(std::rand()) / RAND_MAX;
						r *= 1.5;
						data.value *= r;
					}
				}
			}
		}
	}
}

void Node::setAsChildOf(const Node& p0, const Node& p1)
{
	type = Type::FUNCTION;
	double r = double(std::rand()) / RAND_MAX;
	if (r < 0.25)		subType.functionType = FunctionType::ADD;
	else if (r < 0.50)	subType.functionType = FunctionType::SUBSTRACT;
	else if (r < 0.75)	subType.functionType = FunctionType::MULTIPLY;
	else				subType.functionType = FunctionType::DIVIDE;

	data.children.child0 = new Node();
	data.children.child1 = new Node();
	*data.children.child0 = p0.getRandomBrach();
	*data.children.child1 = p1.getRandomBrach();
}

int Node::getDepth() const
{
	if (type == Type::TERMINAL) return 1;
	return std::max(data.children.child0->getDepth(), data.children.child1->getDepth()) + 1;
}

std::string Node::getString()
{
	if (type == Type::TERMINAL)
	{
		if (subType.terminalType == TerminalType::VARIABLE) return "x";
		else return std::to_string(data.value);
	}

	std::string s = "(";
	s += data.children.child0->getString();
	switch (subType.functionType)
	{
	case FunctionType::ADD:
		s += "+";
		break;
	case FunctionType::SUBSTRACT:
		s += "-";
		break;
	case FunctionType::MULTIPLY:
		s += "*";
		break;
	case FunctionType::DIVIDE:
		s += "/";
		break;
	}
	s += data.children.child1->getString();
	s += ")";
	return s;
}

Node Node::getRandomBrach() const
{
	if (type == Type::TERMINAL) return *this;

	double r = double(std::rand()) / RAND_MAX;

	if (r < 0.5) return *this;

	if (r < 0.75)	return data.children.child0->getRandomBrach();
	else			return data.children.child1->getRandomBrach();
}