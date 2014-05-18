/*
 * Histogramm.cpp
 *
 *  Created on: Apr 23, 2014
 *      Author: md
 */

#include "Histogramm.h"

Histogramm::Histogramm() {
	// TODO Auto-generated constructor stub

}

Histogramm::Histogramm(Mat img, int hBins, int sBins){
	this->hBins = hBins;
	this->sBins = sBins;
	int histSize[] = { hBins, sBins };
	float hRanges[] = { 0, 180 };
	float sRanges[] = { 0, 256 };
	const float* ranges[] = { hRanges, sRanges };
	int channels[] = { 0, 1 };
	calcHist( &img, 1, channels, Mat(), // do not use mask
	                 this->hist, 2, histSize, ranges,
	                 true, // the histogram is uniform
	                 false );
	normalize( this->hist, this->hist, 0, 1, NORM_MINMAX, -1, Mat() );

}
Histogramm::~Histogramm() {
	// TODO Auto-generated destructor stub
	hist = MatND();
}

double Histogramm::compare(Histogramm *compareToHist){
	return compareHist( hist, compareToHist->hist, CV_COMP_BHATTACHARYYA );

}

void Histogramm::clear(){
	hist = MatND();
}
