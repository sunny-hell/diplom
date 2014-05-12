/*
 * CalculationResult.h
 *
 *  Created on: Apr 29, 2014
 *      Author: md
 */

#ifndef CALCULATIONRESULT_H_
#define CALCULATIONRESULT_H_

#include <Eigen/Dense>


using namespace Eigen;

class CalculationResult {
public:

	CalculationResult();
	virtual ~CalculationResult();

	void setQualityIndex(VectorXd qInd);
	void setDists(VectorXd dists);
	void setFrameNums(int firstFrame, int lastFrame);
	VectorXd getQualityIndex();
	VectorXd getDists();
	VectorXd getFrameNums();
	double getAverageQuality();
	void initWeights(int frameNum, int particlesNum);
	void setWeightsForFrame(int f, VectorXd wgts);
	MatrixXd getWeights();
private:
	VectorXd qualityIndex;
	VectorXd frameNum;
	VectorXd dists;
	MatrixXd weights;
	double avgQuality;
};

#endif /* CALCULATIONRESULT_H_ */
