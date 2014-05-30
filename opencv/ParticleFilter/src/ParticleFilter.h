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
#include "config.h"


using namespace std;
using namespace Eigen;

class ParticleFilter {
public:
	ParticleFilter();
	ParticleFilter(int N, int hBins, int sBins, Histogramm *templHist, double initDevs[], int frameW, int frameH, int nFrames, bool adaptive, bool withUpdateModel);
	ParticleFilter(Config *cnf, Histogramm *templHist, int frameW, int frameH, int nFrames);
	virtual ~ParticleFilter();

	void prepareFirstSet(Rect r);
	void prepareFirstSetRandom(Rect r, double w, double h);
	void prepareFirstSetAtPoint(Rect r, Point *p);
	void iter(Mat frame, int k);
	Rect* getSetAsRects();
	Point* getSetAsPoints();
	Rect getEstimatedState();
	VectorXd dists;
	VectorXd observationProbability;
	VectorXd getWeights();


	void estimateState();

private:
	MatrixXd particles;
	vector<vector<double>> clusters;
	VectorXd clusterMap;
	Histogramm *templateHist;
	Rect estimatedState;
	struct Config *cnf;
	VectorXd initialDevs;
	double wgtCoeff;
	MatrixXd A;
	WhiteNoiseGenerator *noiseGen;
	int frameWidth;
	int frameHeight;
	VectorXd qualityIndex;
	int nFrames;
	int N;

};

#endif /* PARTICLEFILTER_H_ */
