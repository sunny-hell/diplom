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
	avgQuality = qInd.sum() / qInd.rows();
}

void CalculationResult::setFrameNums(int firstFrame, int lastFrame){
	frameNum.resize(lastFrame-firstFrame+1);
	frameNum.setLinSpaced(firstFrame, lastFrame);
}
void CalculationResult::setDists(VectorXd dists){
	this->dists = dists;
}

VectorXd CalculationResult::getQualityIndex(){
	return qualityIndex;
}

double CalculationResult::getAverageQuality(){
	return avgQuality;
}
VectorXd CalculationResult::getDists(){
	return dists;
}

VectorXd CalculationResult::getFrameNums(){
	return frameNum;
}
