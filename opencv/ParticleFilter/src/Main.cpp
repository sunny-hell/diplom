
#include "VideoProcessor.h"
#include <Eigen/Dense>

#include <math.h>

#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>

int main(int ac, char** av)
{
	double devs[8] = {15, 15, 0.1, 0.1, 1, 1, 0.01, 0.01};


	try{
	VideoProcessor *processor = new VideoProcessor("E:\\bmstu\\diplom\\12_sem\\sample_videos\\movie10.mjpeg", "E:\\bmstu\\diplom\\12_sem\\gt\\ferrari\\movie10.txt", "E:\\bmstu\\diplom\\12_sem\\gt\\ferrari\\ref_hist_10.jpg", "E:\\bmstu\\diplom\\12_sem\\SIR_Adaptive\\results\\movie10_nonadaptive_800.txt", "ferrari", devs, false);

	processor->processVideo();
	}
	catch (exception& e){
		cout << "Exception e: " << e.what() << endl;
	}

	return 0;
}


