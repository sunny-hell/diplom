/*
 * WhiteNoiseGenerator.cpp
 *
 *  Created on: Apr 28, 2014
 *      Author: md
 */

#include "WhiteNoiseGenerator.h"

WhiteNoiseGenerator::WhiteNoiseGenerator():
	gener(time(NULL)), normal(boost::normal_distribution<double>()), randN(gener, normal) {
	// TODO Auto-generated constructor stub

}

void WhiteNoiseGenerator::setCovar(Eigen::VectorXd devs){

	Eigen::MatrixXd covarMat = devs.asDiagonal();
	Eigen::SelfAdjointEigenSolver<Eigen::Matrix<double,8,8>>
	           eigenSolver(covarMat);
	rot = eigenSolver.eigenvectors();
	scl = eigenSolver.eigenvalues();
	for (int ii=0;ii<8;++ii) {
		scl(ii,0) = sqrt(scl(ii,0));
	}
}

Eigen::VectorXd WhiteNoiseGenerator::nextSample(){
	Eigen::VectorXd sampleVec(8);
	for (int ii=0;ii<8;ii++) {
		sampleVec(ii,0) = randN()*scl(ii,0);
	}
	sampleVec = rot*sampleVec;
	return sampleVec;
}

WhiteNoiseGenerator::~WhiteNoiseGenerator() {
	// TODO Auto-generated destructor stub
}
