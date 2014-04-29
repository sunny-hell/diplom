
#include "VideoProcessor.h"
#include <Eigen/Dense>

#include <math.h>

#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>

int main(int ac, char** av)
{
	double devs[8] = {15, 15, 0.2, 0.2, 1, 1, 0.02, 0.02};


	try{
	VideoProcessor *processor = new VideoProcessor("C:\\published_testset_FerrariF40\\movies\\movie01.mjpeg", "C:\\published_testset_FerrariF40\\groundtruth\\movie01.txt", "C:\\PF\\result.txt", "ferrari", devs);

	processor->processVideo();
	}
	catch (exception& e){
		cout << "Exception e: " << e.what() << endl;
	}

	return 0;
}


