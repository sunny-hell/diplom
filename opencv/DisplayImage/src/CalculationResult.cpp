/*
 * CalculationResult.cpp
 *
 *  Created on: Apr 29, 2014
 *      Author: md
 */

#include "CalculationResult.h"

CalculationResult::CalculationResult() {
	// TODO Auto-generated constructor stub

}

CalculationResult::~CalculationResult() {
	// TODO Auto-generated destructor stub
}

void CalculationResult::setQualityIndex(VectorXd qInd){
	qualityIndex = qInd;
	avgQuality = qInd.sum() / qInd.cols();
}

void CalculationResult::setDists(VectorXd dists){
	this->dists = dists;
}

VectorXd CalculationResult::getQualityIndex(){
	return qualityIndex;
}

VectorXd CalculationResult::getDists(){
	return dists;
}
