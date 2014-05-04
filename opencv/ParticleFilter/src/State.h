/*
 * State.h
 *
 *  Created on: Apr 22, 2014
 *      Author: md
 */

#ifndef STATE_H_
#define STATE_H_

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include <opencv2/imgproc/imgproc.hpp>
#include <math.h>

using namespace cv;

class State {
	public:

		float x;
		float y;
		float w;
		float h;
		int frameNum;

		State();
		State(float x, float y, float w, float h, int frameNum);
		State(Rect r, int frameNum);
		virtual ~State();

		Rect getRect();
		double getQualityIndex(Rect r);
	};

#endif /* STATE_H_ */
