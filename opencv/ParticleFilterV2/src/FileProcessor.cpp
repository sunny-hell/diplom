/*
 * FileProcessor.cpp
 *
 *  Created on: Apr 22, 2014
 *      Author: md
 */


#include "FileProcessor.h"




FileProcessor::FileProcessor() {
	// TODO Auto-generated constructor stub

}

FileProcessor::~FileProcessor() {
	// TODO Auto-generated destructor stub
}

State** FileProcessor::readGTStates(const char *fname, const char *gtType, int *firstFrameNum, int *lastFrameNum){
	ifstream inputFile;
	inputFile.open(fname, ifstream::in);
	string line;
	int nFrames = count(istreambuf_iterator<char>(inputFile),
	      istreambuf_iterator<char>(), '\n');
	cout << "num of frames in ground truth " << nFrames << endl;
	State **states = new State*[nFrames];
	inputFile.seekg(0, ios::beg);
	int i;
	int frameNum;
	for (i=0; i<nFrames; i++){
		getline(inputFile, line);
		istringstream iss(line);
		if (strcmp(gtType, "ferrari") == 0){
			float x,y,w,ar;

			iss >> frameNum >> x >> y >> w >> ar;
			states[i] = new State(x,y,w,w*ar, frameNum);
			if (i==0){
				*firstFrameNum = frameNum;
			}
		}
	}
	*lastFrameNum = frameNum;
	inputFile.close();
	return states;
}

void FileProcessor::writeNumbers(const char *fname, VectorXd numbers){
	ofstream outfile;
	outfile.open(fname);
	for (int i = 0; i < numbers.cols(); i++)
	{
		outfile << numbers(i) << '\t';
	}

	outfile.close();
}

void FileProcessor::saveCalculationResult(const char *fName, CalculationResult *res){
	ofstream outfile;
	outfile.open(fName);
	VectorXd dists = res->getDists();
	VectorXd qualityIndex = res->getQualityIndex();
	VectorXd frameNums = res->getFrameNums();
	int N = qualityIndex.rows();
	int M = frameNums.rows();
	cout << "N= " << N <<  " M= "<< M <<  endl;
	for (int i = 0; i < N; i++){
		outfile << frameNums(i) << '\t' << qualityIndex(i) << '\n';
	}

	outfile.close();
}

