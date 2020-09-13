#pragma once

#include <SDL.h>
#include <SDL_image.h>
#include <SDL_ttf.h>

#include "Constants.h"
#include "Model.h"

class Renderer
{
private:
	SDL_Renderer* context;

	SDL_Texture* canvasTex;
	Uint32 canvasValues[Constants::RES_H][Constants::RES_W];

	static const Uint32 COLOR_BG = 0xff000000;
	static const Uint32 COLOR_WALL = 0xff999999;
	static const Uint32 COLOR_CIRCLE = 0xffffffff;
	static const Uint32 COLOR_AABB = 0xff00ff00;

public:
	Renderer();
	~Renderer();

	void initialize(SDL_Renderer* context);
	void render(const Model& model, int aabbStart, int aabbEnd);

	void clear();
	void drawLine(int sy, int sx, int ey, int ex, Uint32 color);
	void drawCircle(int cy, int cx, int r);

private:
	void updateCanvasTex();
	void renderCanvas();

	void checkAndSetPixel(int y, int x, Uint32 color);
};

