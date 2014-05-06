/*
 * RegionExtractor.cpp
 *
 *  Created on: 06.05.2014
 *      Author: sunny-hell
 */

#include "RegionExtractor.h"

RegionExtractor::RegionExtractor() {
	// TODO Auto-generated constructor stub

}

RegionExtractor::RegionExtractor(double minW, double maxW, double minH, double maxH) {
	// TODO Auto-generated constructor stub
	this->minW = minW;
	this->maxW = maxW;
	this->minH = minH;
	this->maxH = maxH;

}

vector<Rect> RegionExtractor::getBoundRects(Mat frame){
	Mat fore;
	vector<vector<Point> > contours;
	vector<Point> contourPoly;
	vector<Rect> boundRects;

	bg.operator ()(frame,fore);
	erode(fore, fore, Mat());
	dilate(fore, fore, Mat());
	findContours(fore, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
	int N = contours.size();

	if (N > 0){
		for (int i=0; i<N; i++){
			approxPolyDP(contours[i], contourPoly, 3, true );
			Rect r = boundingRect(contourPoly);
			boundRects.push_back(r);

		}
	}
	return boundRects;
}
RegionExtractor::~RegionExtractor() {
	// TODO Auto-generated destructor stub
}
