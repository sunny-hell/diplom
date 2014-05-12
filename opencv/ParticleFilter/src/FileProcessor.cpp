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

State** FileProcessor::readGTStatesFerrari(const char *fname, int *firstFrameNum, int *lastFrameNum){
	ifstream inputFile;
	inputFile.open(fname, ifstream::in);
	int nFrames = count(istreambuf_iterator<char>(inputFile), istreambuf_iterator<char>(), '\n');
	cout << "num of frames in ground truth " << nFrames << endl;
	State **states = new State*[nFrames];
	int frameNum;
	string line;
	inputFile.seekg(0, ios::beg);
	for (int i=0; i<nFrames; i++){
		getline(inputFile, line);
		istringstream iss(line);
		float x,y,w,ar;

		iss >> frameNum >> x >> y >> w >> ar;
		states[i] = new State(x,y,w,w*ar, frameNum);
		if (i==0){
			*firstFrameNum = frameNum;
		}

	}
	*lastFrameNum = frameNum;
	inputFile.close();
	return states;
}

State** FileProcessor::readGTStatesBobot(const char *fname, int *firstFrameNum, int *lastFrameNum, int frameWidth, int frameHeight){
	ifstream inputFile;
	inputFile.open(fname, ifstream::in);

	int nFrames = count(istreambuf_iterator<char>(inputFile), istreambuf_iterator<char>(), '\n');
	cout << "num of frames in ground truth " << nFrames << endl;
	State **states = new State*[nFrames];
	string line;
	int frameNum;
	inputFile.seekg(0, ios::beg);
	for (int i=0; i<nFrames; i++){
		getline(inputFile, line);
		istringstream iss(line);
		float x,y,w,h;

		iss >> frameNum >> x >> y >> w >> h;
		states[i] = new State(x*frameWidth,y*frameHeight,w*frameWidth,h*frameHeight, frameNum);
		if (i==0){
			*firstFrameNum = frameNum;
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

void FileProcessor::saveWeigts(const char *fName, MatrixXd wgts){
	ofstream outfile;
	outfile.open(fName);
	for (int i=0; i<wgts.rows(); i++){
		for (int j=0; j<wgts.cols(); j++){
			outfile << wgts(i,j) << '\t';

		}
		outfile << '\n';
	}
	outfile.close();
}
