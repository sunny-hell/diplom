/*
 * config.h
 *
 *  Created on: 17.05.2014
 *      Author: sunny-hell
 */

#ifndef CONFIG_H_
#define CONFIG_H_

struct Config{
	double devs[8];
	const char *srcVideo;
	const char *srcGT;
	const char *srcHist;
	const char *res;
	const char *gtTag;
	const char *fNameWeights;
	const char *fNameFramesToInit;
	const char *fNameQualityEstimation;
	int iterationsCount;
	int N;
	int hBins;
	int sBins;
	double alpha;
	double beta;
	double gamma;
	double threshold;

	bool isAdaptive;
	bool withUpdateModel;


	Config(){
		srcVideo = "";
		srcGT = "";
		srcHist = "";
		res = "";
		gtTag = "";
		fNameWeights = "";
		fNameFramesToInit = "";
		fNameQualityEstimation = "";
		iterationsCount = 0;
		N = 800;
		hBins = 50;
		sBins = 60;
		alpha = 8.0;
		beta = 0.5;
	}

};

#endif /* CONFIG_H_ */
