/*
 * WhiteNoiseGenerator.h
 *
 *  Created on: Apr 28, 2014
 *      Author: md
 */

#ifndef WHITENOISEGENERATOR_H_
#define WHITENOISEGENERATOR_H_

#include <Eigen/Dense>
#define _USE_MATH_DEFINES
#include <math.h>
#include <time.h>

#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>


class WhiteNoiseGenerator {
public:
	WhiteNoiseGenerator();

	Eigen::VectorXd nextSample();
	void setCovar(Eigen::VectorXd devs);

	virtual ~WhiteNoiseGenerator();
private:
	boost::mt19937 gener;
	boost::normal_distribution<double> normal;
	boost::variate_generator<boost::mt19937&,boost::normal_distribution<double> > randN;
	Eigen::MatrixXd rot;
	Eigen::MatrixXd scl;
};

#endif /* WHITENOISEGENERATOR_H_ */
