#include "Renderer.h"

#include <cmath>
#include <algorithm> // for swap

using std::swap;

Renderer::Renderer()
{
}


Renderer::~Renderer()
{
}

void Renderer::initialize(SDL_Renderer* context_)
{
	context = context_;

	canvasTex = SDL_CreateTexture(context, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STREAMING, Constants::RES_W, Constants::RES_H);
}

void Renderer::render(const Model& model, int aabbStart, int aabbEnd)
{
	clear();

	const int OX = 50;
	const int OY = 50;

	for (int i = 0; i < model.numLines; i++)
	{
		drawLine(model.lineys[2 * i] + OY, model.linexs[2 * i] + OX, model.lineys[2 * i + 1] + OY, model.linexs[2 * i + 1] + OX, COLOR_WALL);
	}
	for (int i = 0; i < model.numCircles; i++)
	{
		drawCircle(model.gety(i) + OY, model.getx(i) + OX, model.rs[i]);
	}
	for (int i = aabbStart; i < aabbEnd; i++)
	{
		const auto& a = model.getaabb(i);
		drawLine(a.miny + OY, a.minx + OX, a.maxy + OY, a.minx + OX, COLOR_AABB);
		drawLine(a.miny + OY, a.maxx + OX, a.maxy + OY, a.maxx + OX, COLOR_AABB);
		drawLine(a.miny + OY, a.minx + OX, a.miny + OY, a.maxx + OX, COLOR_AABB);
		drawLine(a.maxy + OY, a.minx + OX, a.maxy + OY, a.maxx + OX, COLOR_AABB);
	}

	updateCanvasTex();
	renderCanvas();
	SDL_RenderPresent(context);
}

void Renderer::clear()
{
	SDL_RenderClear(context);

	for (int y = 0; y < Constants::RES_H; y++)
	{
		for (int x = 0; x < Constants::RES_W; x++)
		{
			canvasValues[y][x] = COLOR_BG;
		}
	}
}

void Renderer::updateCanvasTex()
{
	static const SDL_Rect canvasRect{ 0, 0, Constants::RES_W, Constants::RES_H };
	SDL_UpdateTexture(canvasTex, &canvasRect, canvasValues, 4 * Constants::RES_W);
}

void Renderer::renderCanvas()
{
	static const SDL_Rect destRect{ 0, 0, Constants::WIN_W, Constants::WIN_H };
	SDL_RenderCopy(context, canvasTex, NULL, &destRect);
}

void Renderer::drawLine(int sy, int sx, int ey, int ex, Uint32 color)
{
	bool steep = abs(ey - sy) > abs(ex - sx);

	if (steep)
	{
		if (ey < sy)
		{
			swap(sx, ex);
			swap(sy, ey);
		}

		int dx = ex - sx;
		int dy = ey - sy;
		int dirx = 1;
		if (dx < 0)
		{
			dx *= -1;
			dirx = -1;
		}
		int x = sx;
		int err = dy / 2;
		for (int y = sy; y <= ey; y++)
		{
			checkAndSetPixel(y, x, color);

			err += dx;
			if (err > dy)
			{
				err -= dy;
				x += dirx;
			}
		}
	}
	else
	{
		if (ex < sx)
		{
			swap(sx, ex);
			swap(sy, ey);
		}

		int dx = ex - sx;
		int dy = ey - sy;
		int diry = 1;
		if (dy < 0)
		{
			dy *= -1;
			diry = -1;
		}
		int y = sy;
		int err = dx / 2;
		for (int x = sx; x <= ex; x++)
		{
			checkAndSetPixel(y, x, color);

			err += dy;
			if (err > dx)
			{
				err -= dx;
				y += diry;
			}
		}
	}
}

void Renderer::drawCircle(int cy, int cx, int r)
{
	int r2 = r * r;

	int y = 0;
	int x = r;
	while (y <= x)
	{
		int errNow = abs(y * y + x * x - r2);
		int errThen = abs(y * y + (x - 1) * (x - 1) - r2);
		if (errThen < errNow)
		{
			x--;
		}

		checkAndSetPixel(cy + y, cx + x, COLOR_CIRCLE);
		checkAndSetPixel(cy + x, cx + y, COLOR_CIRCLE);
		checkAndSetPixel(cy + y, cx - x, COLOR_CIRCLE);
		checkAndSetPixel(cy + x, cx - y, COLOR_CIRCLE);
		checkAndSetPixel(cy - y, cx - x, COLOR_CIRCLE);
		checkAndSetPixel(cy - x, cx - y, COLOR_CIRCLE);
		checkAndSetPixel(cy - y, cx + x, COLOR_CIRCLE);
		checkAndSetPixel(cy - x, cx + y, COLOR_CIRCLE);

		y++;
	}
}

void Renderer::checkAndSetPixel(int y, int x, Uint32 color)
{
	if (y < 0) return;
	if (y >= Constants::RES_H) return;
	if (x < 0) return;
	if (x >= Constants::RES_W) return;

	canvasValues[y][x] = color;
}