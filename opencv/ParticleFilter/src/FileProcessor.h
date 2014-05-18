/*
 * FileProcessor.h
 *
 *  Created on: Apr 22, 2014
 *      Author: md
 */

#ifndef FILEPROCESSOR_H_
#define FILEPROCESSOR_H_

#include <string>
#include <sstream>
#include <fstream>
#include <iostream>
#include <algorithm>
#include <Eigen/Dense>
#include "State.h"
#include "CalculationResult.h"
#include "Histogramm.h"
#include "config.h"
using namespace std;
using namespace Eigen;

class FileProcessor {
public:
	FileProcessor();
	virtual ~FileProcessor();

	State** readGTStatesFerrari(const char *fname, int *firstFrameNum, int *lastFrameNum);
	State** readGTStatesBobot(const char *fname, int *firstFrameNum, int *lastFrameNum, int frameWidth, int frameHeight);
	void writeNumbers(const char *fname, VectorXd numbers);
	void saveCalculationResult(const char *fName, CalculationResult *res);
	void saveWeigts(const char *fName, MatrixXd wgts);
	void writeHSHist(const char *fname, Histogramm *hist);
	struct Config readConfig(const char *fNameConfig);
};

#endif /* FILEPROCESSOR_H_ */
