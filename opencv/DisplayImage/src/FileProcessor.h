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

using namespace std;
using namespace Eigen;

class FileProcessor {
public:
	FileProcessor();
	virtual ~FileProcessor();

	State** readGTStates(const char *fname, const char *gtType, int *firstFrameNum, int *lastFrameNum);
	void writeNumbers(const char *fname, VectorXd numbers);
	void saveCalculationResult(const char *fName, CalculationResult *res);
};

#endif /* FILEPROCESSOR_H_ */
