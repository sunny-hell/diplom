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
	VectorXd getQualityIndex();
	VectorXd getDists();
private:
	VectorXd qualityIndex;
	VectorXd dists;
	double avgQuality;
};

#endif /* CALCULATIONRESULT_H_ */
