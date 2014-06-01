/*
 * Histogramm.h
 *
 *  Created on: Apr 23, 2014
 *      Author: md
 */

#ifndef HISTOGRAMM_H_
#define HISTOGRAMM_H_

#include "opencv2/core/core.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

using namespace cv;

class Histogramm {
public:
	Histogramm();
	Histogramm(Mat img, int hBins, int sBins);
	Histogramm(Mat img, int bins);
	virtual ~Histogramm();

	MatND hist;
	MatND rgbHist;
	int hBins;
	int sBins;
	int bins;

	double compare(Histogramm *compareToHist);
	void clear();
};

#endif /* HISTOGRAMM_H_ */
