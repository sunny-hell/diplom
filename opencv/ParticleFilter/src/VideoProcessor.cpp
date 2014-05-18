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
	this->fNameWeights = "";
	for (int i=0; i<8; i++){
		this->devs[i] = devs[i];
	}
}

VideoProcessor::~VideoProcessor() {
	// TODO Auto-generated destructor stub
}

void VideoProcessor::setFileNameForWeights(const char *fName){
	fNameWeights = fName;
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
	capture.open(fNameVideo);
	int width = capture.get(CV_CAP_PROP_FRAME_WIDTH);
	int height = capture.get(CV_CAP_PROP_FRAME_HEIGHT);
	cout << "width: " << width << endl;
	cout << "height: " << height << endl;
	if (strcmp(gtType, "ferrari") == 0){
		states = fp->readGTStatesFerrari(fNameGT, &firstFrame, &lastFrame);
	} else if (strcmp(gtType, "bobot") == 0){
		states = fp->readGTStatesBobot(fNameGT, &firstFrame, &lastFrame, width, height);
	}
	cout << "firstFrame: " << firstFrame << " lastFrame: " << lastFrame << endl;
	string winName = "pf";
	namedWindow(winName, CV_WINDOW_AUTOSIZE);

	shiftToFrame(firstFrame-1);

	Mat frame, hsvFrame;
	capture >> frame;
	cvtColor(frame, hsvFrame, CV_RGB2HSV);
	Mat templObj;
	Mat templObjHsv;
	if (strlen(fNameRefHist) > 0 ){
		templObj= imread(fNameRefHist, CV_LOAD_IMAGE_COLOR);
		cvtColor(templObj, templObjHsv, CV_RGB2HSV);
	} else {
		templObjHsv = Mat(hsvFrame, states[0]->getRect());
		rectangle(frame, states[0]->getRect(), Scalar(0,255,0,0));
	}
	Histogramm* templateHist = new Histogramm(templObjHsv, 50, 60);
	//fp->writeHSHist("firstFrameHist.txt", templateHist);
	//imshow(winName, frame);
	//waitKey(3);
	//return;
	cout << capture.get(CV_CAP_PROP_POS_FRAMES) << endl;
	int nFrames = lastFrame-firstFrame+1;
	ParticleFilter *pf = new ParticleFilter(800, 50, 60, templateHist, devs, width, height, nFrames, adaptive);
	//pf->setClustersNum(2);
	cout << "before prepare first set" << endl;
	pf->prepareFirstSet(states[0]->getRect());
	cout << "after prepare first set" << endl;
	//State *estimatedStates[nFrames];
	VectorXd qualityIndex(nFrames);
	//ostringstream oss;
	CalculationResult *result = new CalculationResult();
	result->initWeights(nFrames, 800);

	vector<Scalar> colors(2);
	colors[0] = Scalar(255, 0,0,0);
	colors[1] = Scalar(0, 255,0,0);
	MatrixXd clusters;
	for (int i=firstFrame; i<=lastFrame; i++){
		//cout << "frame " << i << endl;
		pf->iter(hsvFrame, i-firstFrame);
		//pf->calcClusters();
		result->setWeightsForFrame(i-firstFrame, pf->getWeights());
		Rect estRect = pf->getEstimatedState();
		qualityIndex(i-firstFrame) = states[i-firstFrame]->getQualityIndex(estRect);

		//cout << estRect.x << " " << estRect.y << " " << estRect.width << " " << estRect.height << endl;
		Point *points = pf->getSetAsPoints();
		//clusters = pf->getSetAsClusters();
		//cout << "clusters: " <<  clusters.rows() << " X " << clusters.cols() << endl;
		//for (int j=0; j<clusters.rows(); j++)
		//	circle(frame, Point(clusters(j,0), clusters(j,1)),1, colors[clusters(j,2)]);
		for (int j=0; j<800; j++)
			circle(frame, points[j],1, Scalar(0,255,0, 0));

		rectangle(frame, estRect, Scalar(0,0,255,0));

		imshow(winName, frame);
		//cout << "after imshow " << endl;
		/*oss << "..//results//" << i << ".jpg";
		imwrite(oss.str(), frame);
		oss.str("");
		*/
		waitKey(1);
		frame = Mat();
		//cout << "before frame captured" << endl;
		capture >> frame;
		//cout << "captured new frame" << endl;
		cvtColor(frame, hsvFrame, CV_RGB2HSV);
	}

	result->setQualityIndex(qualityIndex);
	result->setFrameNums(firstFrame, lastFrame);
	cout << result->getAverageQuality();
	if (adaptive){
		result->setDists(pf->dists);
	}
	fp->saveCalculationResult(fNameResult, result);
	if (strlen(fNameWeights) > 0){
		fp->saveWeigts(fNameWeights, result->getWeights());
	}
	//double avgQuality = qualityIndex.sum() / nFrames;
	//cout << "avg quality: " << avgQuality << endl;
	waitKey(1);

	capture.release();
	delete[] states;
}


