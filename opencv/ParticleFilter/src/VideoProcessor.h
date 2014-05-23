/*
 * VideoProcessor.h
 *
 *  Created on: Apr 23, 2014
 *      Author: md
 */

#ifndef VIDEOPROCESSOR_H_
#define VIDEOPROCESSOR_H_

#include "opencv2/highgui/highgui.hpp"
#include <opencv2/objdetect/objdetect.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <iostream>
#include <sstream>
#include <vector>
#include <stdio.h>
#include "FileProcessor.h"
#include "Histogramm.h"
#include "ParticleFilter.h"
#include "CalculationResult.h"
#include "config.h"

using namespace std;

class VideoProcessor {
public:
	VideoProcessor();
	VideoProcessor(const char *videoFile, const char *gtFile, const char *refHistFile,  const char *resFile, const char *gtType,  double devs[], bool adaptive);
	VideoProcessor(struct Config *cnf);
	virtual ~VideoProcessor();

	void processVideo();
	void estimateTimeToDetect();
	void estimateQuality();
	void setFileNameForWeights(const char* fName);
private:
	const char *fNameVideo;
	const char *fNameGT;
	const char *fNameRefHist;
	const char *fNameResult;
	const char* gtType;
	const char* fNameWeights;
	const char* fNameFramesToInit;
	const char* fNameQualityEstimation;
	int iterationsCount;
	//int process(VideoCapture& capture);
	State **states;
	VideoCapture capture;
	double devs[8];
	bool adaptive;
	Histogramm *templateHist;
	void shiftToFrame(int frameNum);
	void prepareToTracking(int *firstFrame, int *lastFrame, int *width, int *height, Mat *frame, Mat *hsvFrame);
};

#endif /* VIDEOPROCESSOR_H_ */
