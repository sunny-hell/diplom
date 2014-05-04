/*
 * ParticleFilter.h
 *
 *  Created on: Apr 24, 2014
 *      Author: md
 */

#ifndef PARTICLEFILTER_H_
#define PARTICLEFILTER_H_

#include "Histogramm.h"
#include <random>

#include <iostream>
#include <math.h>
#include <exception>
#include "WhiteNoiseGenerator.h"


using namespace std;
using namespace Eigen;

class ParticleFilter {
public:
	ParticleFilter();
	ParticleFilter(int N, int hBins, int sBins, Histogramm *templHist, double initDevs[], int frameW, int frameH, int nFrames, bool adaptive);
	virtual ~ParticleFilter();

	void prepareFirstSet(Rect r);
	void iter(Mat frame, int k);
	Rect* getSetAsRects();
	Rect getEstimatedState();
	VectorXd dists;
private:
	int N;
	MatrixXd particles;
	Histogramm *templateHist;
	Rect estimatedState;
	//double initialDevs[8];
	void estimateState();
	int hBins;
	int sBins;
	double alpha;
	double beta;
	double wgtCoeff;
	VectorXd initialDevs;
	MatrixXd A;
	WhiteNoiseGenerator *noiseGen;
	int frameWidth;
	int frameHeight;
	bool adaptive;
	VectorXd qualityIndex;
	int nFrames;

};

#endif /* PARTICLEFILTER_H_ */
