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

using namespace std;

class VideoProcessor {
public:
	VideoProcessor();
	VideoProcessor(const char *videoFile, const char *gtFile, const char *refHistFile,  const char *resFile, const char *gtType,  double devs[], bool adaptive);
	virtual ~VideoProcessor();

	void processVideo();
	void setFileNameForWeights(const char* fName);
private:
	const char *fNameVideo;
	const char *fNameGT;
	const char *fNameRefHist;
	const char *fNameResult;
	const char* gtType;
	const char* fNameWeights;
	//int process(VideoCapture& capture);
	State **states;
	VideoCapture capture;
	double devs[8];
	bool adaptive;
	void shiftToFrame(int frameNum);
};

#endif /* VIDEOPROCESSOR_H_ */
