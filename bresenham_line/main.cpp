#include "SDL.h"
#include <cmath>
#include <utility>

//Bresenham's line algorithm
SDL_Texture* createLineTexture(SDL_Renderer* ren, int w, int h, float x1, float y1, float x2, float y2)
{
	SDL_Texture* tex = SDL_CreateTexture(ren, SDL_PIXELFORMAT_ARGB8888, SDL_TEXTUREACCESS_STATIC, w, h);
	SDL_SetTextureBlendMode(tex, SDL_BLENDMODE_BLEND);

	Uint32* pixels = new Uint32[w*h];
	for (int i = 0; i<w*h; i++)
	{
		pixels[i] = 0;
	}

	Uint32 colorValue = 0xffffffff;

	// Bresenham's line algorithm
	const bool steep = (fabs(y2 - y1) > fabs(x2 - x1));
	if (steep)
	{
		std::swap(x1, y1);
		std::swap(x2, y2);
	}

	if (x1 > x2)
	{
		std::swap(x1, x2);
		std::swap(y1, y2);
	}

	const float dx = x2 - x1;
	const float dy = fabs(y2 - y1);

	float error = dx / 2.0f;
	const int ystep = (y1 < y2) ? 1 : -1;
	int y = (int)y1;

	const int maxX = (int)x2;

	for (int x = (int)x1; x<maxX; x++)
	{
		if (steep)
		{
			pixels[x*w + y] = colorValue;
		}
		else
		{
			pixels[y*w + x] = colorValue;
		}

		error -= dy;
		if (error < 0)
		{
			y += ystep;
			error += dx;
		}
	}

	SDL_Rect rect{ 0, 0, w, h };
	SDL_UpdateTexture(tex, &rect, pixels, w * 4);

	delete[] pixels;

	return tex;
}

int main(int argc, char** argv){
	SDL_Init(SDL_INIT_EVERYTHING);
	SDL_Window *win = SDL_CreateWindow("Hello World!", 200, 100, 600, 400, SDL_WINDOW_SHOWN);
	SDL_Renderer *ren = SDL_CreateRenderer(win, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	SDL_Texture *tex = createLineTexture(ren, 600, 400, 50, 50, 550, 350);
	SDL_RenderClear(ren);
	SDL_Rect destRect{ 0, 0, 600, 400 };
	SDL_RenderCopy(ren, tex, NULL, &destRect);
	SDL_RenderPresent(ren);
	SDL_Delay(3000);
	SDL_DestroyTexture(tex);
	SDL_DestroyRenderer(ren);
	SDL_DestroyWindow(win);
	SDL_Quit();

	return 0;
}