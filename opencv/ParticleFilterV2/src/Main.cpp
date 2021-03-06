
#include "VideoProcessor.h"
#include <Eigen/Dense>

#include <math.h>

#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>

#include <opencv2/highgui/highgui.hpp>
#include <opencv2/video/background_segm.hpp>
#include <opencv2/core/core.hpp>

using namespace cv;
int main(int ac, char** av)
{
	Mat frame; //current frame
	Mat fgMaskMOG; //fg mask generated by MOG method
	Mat fgMaskMOG2; //fg mask fg mask generated by MOG2 method
	Ptr<BackgroundSubtractor> pMOG; //MOG Background subtractor
	Ptr<BackgroundSubtractor> pMOG2; //MOG2 Background subtractor

	pMOG = new BackgroundSubtractorMOG(); //MOG approach
	pMOG2 = new BackgroundSubtractorMOG2(); //MOG2 approach

	namedWindow("Frame");
	namedWindow("FG Mask MOG");
	namedWindow("FG Mask MOG 2");

	VideoCapture capture("C:\\Users\\md\\sunnyhell\\diplom\\testset_FerrariF40\\published_testset_FerrariF40\\movies\\movie01.mjpeg");
	while (capture.read(frame)){
		 pMOG->operator()(frame, fgMaskMOG);
		 pMOG2->operator()(frame, fgMaskMOG2);
		 imshow("Frame", frame);
		 imshow("FG Mask MOG", fgMaskMOG);
		 imshow("FG Mask MOG 2", fgMaskMOG2);
		 waitKey(30);
	}
	capture.release();
	destroyAllWindows();
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


