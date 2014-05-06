
#include "VideoProcessor.h"
#include <Eigen/Dense>

#include <math.h>

#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/video/background_segm.hpp>
#include <opencv2/opencv.hpp>
#include <vector>

#include "RegionExtractor.h"
using namespace cv;
using namespace std;
int main(int ac, char** av)
{
	Mat frame;
	//Mat back;
	//Mat fore;
	VideoCapture capture;
	//BackgroundSubtractorMOG2 bg;
	RegionExtractor *regExtractor = new RegionExtractor();

	//vector<vector<Point> > contours;
	namedWindow("frame");
	namedWindow("fore");
	capture.open("E:\\bmstu\\diplom\\12_sem\\sample_videos\\movie01.mjpeg");
	vector<Rect> bRects;
	while (capture.read(frame)){
		vector<Rect> bRects = regExtractor->getBoundRects(frame);
		int N = bRects.size();
		cout << "found " << N << " contours." << endl;
		for (int i=0; i<N; i++){
			cout << "size: " << bRects[i].width << " X " << bRects[i].height << endl;
			rectangle( frame, bRects[i].tl(), bRects[i].br(), Scalar(255, 0, 0, 0));
		}
		/*
		bg.operator ()(frame,fore);
		erode(fore, fore, Mat());
		dilate(fore, fore, Mat());
		findContours(fore, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_SIMPLE);
		cout << "found " << contours.size() << " contours." << endl;
		vector<vector<Point> > contours_poly( contours.size() );
		vector<Rect> boundRect( contours.size() );

		  for( int i = 0; i < contours.size(); i++ )
		  {
			   approxPolyDP(contours[i], contours_poly[i], 3, true );
		       boundRect[i] = boundingRect( contours_poly[i] );
		       rectangle( frame, boundRect[i].tl(), boundRect[i].br(), Scalar(255, 0, 0, 0));
		  }*/
		//drawContours(frame, contours, -1, Scalar(0,0,255), 2);
 		//bg.getBackgroundImage(back);
		imshow("frame", frame);
		//imshow("fore", fore);
		waitKey(30);
	}
	/*

	double devs[8] = {15, 15, 0.1, 0.1, 1, 1, 0.01, 0.01};


	try{
	VideoProcessor *processor = new VideoProcessor("E:\\bmstu\\diplom\\12_sem\\sample_videos\\movie10.mjpeg", "E:\\bmstu\\diplom\\12_sem\\gt\\ferrari\\movie10.txt", "E:\\bmstu\\diplom\\12_sem\\gt\\ferrari\\ref_hist_10.jpg", "E:\\bmstu\\diplom\\12_sem\\SIR_Adaptive\\results\\movie10_nonadaptive_800.txt", "ferrari", devs, false);

	processor->processVideo();
	}
	catch (exception& e){
		cout << "Exception e: " << e.what() << endl;
	}
	*/

	return 0;
}


