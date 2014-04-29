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
#include <vector>
#include <stdio.h>
#include "FileProcessor.h"
#include "Histogramm.h"
#include "ParticleFilter.h"
#include "CalculationResult.h"

class VideoProcessor {
public:
	VideoProcessor();
	VideoProcessor(const char *videoFile, const char *gtFile, const char *resFile, const char *gtType,  double devs[]);
	virtual ~VideoProcessor();

	void processVideo();

private:
	const char* fNameVideo;
	const char* fNameGT;
	const char *fNameResult;
	const char* gtType;
	//int process(VideoCapture& capture);
	State **states;
	VideoCapture capture;
	double devs[8];
	void shiftToFrame(int frameNum);
};

#endif /* VIDEOPROCESSOR_H_ */
