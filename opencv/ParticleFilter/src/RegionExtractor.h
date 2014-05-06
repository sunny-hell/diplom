/*
 * RegionExtractor.h
 *
 *  Created on: 06.05.2014
 *      Author: sunny-hell
 */

#ifndef REGIONEXTRACTOR_H_
#define REGIONEXTRACTOR_H_

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/video/background_segm.hpp>
#include <opencv2/opencv.hpp>
#include <vector>

using namespace cv;
using namespace std;

class RegionExtractor {
public:
	RegionExtractor();
	RegionExtractor(double minW, double maxW, double minH, double maxH);
	vector<Rect> getBoundRects(Mat frame);
	virtual ~RegionExtractor();
private:
	double minW;
	double maxW;
	double minH;
	double maxH;
	BackgroundSubtractorMOG2 bg;
};

#endif /* REGIONEXTRACTOR_H_ */
