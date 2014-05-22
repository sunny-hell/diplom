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
	int iterationsCount;
	bool isAdaptive;

	Config(){
		srcVideo = "";
		srcGT = "";
		srcHist = "";
		res = "";
		gtTag = "";
		fNameWeights = "";
		fNameFramesToInit = "";
		iterationsCount = 0;
	}

};

#endif /* CONFIG_H_ */
