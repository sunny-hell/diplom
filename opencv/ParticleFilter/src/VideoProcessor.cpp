/*
 * VideoProcessor.cpp
 *
 *  Created on: Apr 23, 2014
 *      Author: md
 */


#include "VideoProcessor.h"


using namespace cv;
using namespace std;

VideoProcessor::VideoProcessor() {
	// TODO Auto-generated constructor stub

}

VideoProcessor::VideoProcessor(const char *videoFile, const char *gtFile, const char *refHistFile, const char *resultFile, const char *gtType, double devs[], bool adaptive) {
	this->fNameVideo = videoFile;
	this->fNameGT = gtFile;
	this->fNameRefHist = refHistFile;
	this->fNameResult = resultFile;
	this->gtType = gtType;
	this->adaptive = adaptive;
	for (int i=0; i<8; i++){
		this->devs[i] = devs[i];
	}
}

VideoProcessor::~VideoProcessor() {
	// TODO Auto-generated destructor stub
}
// перейти к кадру frameNum (с начала видеозаписи)
void VideoProcessor::shiftToFrame(int frameNum){
	int pos=0;
	Mat frame;
	while (pos < frameNum){
		capture >> frame;
		pos++;
	}
	frame = Mat();
}

void VideoProcessor::processVideo(){
	FileProcessor* fp = new FileProcessor();
	int firstFrame, lastFrame;
	states = fp->readGTStates(fNameGT, gtType, &firstFrame, &lastFrame);
	cout << "firstFrame: " << firstFrame << " lastFrame: " << lastFrame << endl;
	string winName = "pf";
	namedWindow(winName, CV_WINDOW_AUTOSIZE);
	capture.open(fNameVideo);
	int width = capture.get(CV_CAP_PROP_FRAME_WIDTH);
	int height = capture.get(CV_CAP_PROP_FRAME_HEIGHT);
	cout << "width: " << width << endl;
	cout << "height: " << height << endl;

	shiftToFrame(firstFrame-1);

	Mat frame, hsvFrame;
	capture >> frame;
	cvtColor(frame, hsvFrame, CV_RGB2HSV);
	Mat templObj = imread(fNameRefHist, CV_LOAD_IMAGE_COLOR);
	Mat templObjHsv;
	cvtColor(templObj, templObjHsv, CV_RGB2HSV);
	//Mat templObjHsv(hsvFrame, states[0]->getRect());
	Histogramm* templateHist = new Histogramm(templObjHsv, 50, 60);


	cout << capture.get(CV_CAP_PROP_POS_FRAMES) << endl;
	int nFrames = lastFrame-firstFrame+1;
	ParticleFilter *pf = new ParticleFilter(800, 50, 60, templateHist, devs, width, height, nFrames, adaptive);
	cout << "before prepare first set" << endl;
	pf->prepareFirstSet(states[0]->getRect());
	cout << "after prepare first set" << endl;
	//State *estimatedStates[nFrames];
	VectorXd qualityIndex(nFrames);

	for (int i=firstFrame; i<=lastFrame; i++){
		//cout << "frame " << i << endl;
		pf->iter(hsvFrame, i-firstFrame);
		Rect estRect = pf->getEstimatedState();
		qualityIndex(i-firstFrame) = states[i-firstFrame]->getQualityIndex(estRect);

		//cout << estRect.x << " " << estRect.y << " " << estRect.width << " " << estRect.height << endl;
		rectangle(frame, pf->getEstimatedState(), Scalar(0,0,255,0));
		imshow(winName, frame);
		waitKey(1);
		capture >> frame;
		cvtColor(frame, hsvFrame, CV_RGB2HSV);
	}
	CalculationResult *result = new CalculationResult();
	result->setQualityIndex(qualityIndex);
	result->setFrameNums(firstFrame, lastFrame);
	cout << result->getAverageQuality();
	if (adaptive){
		result->setDists(pf->dists);
	}
	fp->saveCalculationResult(fNameResult, result);
	//double avgQuality = qualityIndex.sum() / nFrames;
	//cout << "avg quality: " << avgQuality << endl;
	waitKey(1);

	capture.release();
	delete[] states;
}

