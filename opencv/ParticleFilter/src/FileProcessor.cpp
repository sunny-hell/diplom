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
	cout << "rows: " << numbers.rows() << " cols: " << numbers.cols() << endl;
	for (int i = 0; i < numbers.rows(); i++)
	{
		outfile << numbers(i) << '\n';
	}

	outfile.close();
}

void FileProcessor::saveCalculationResult(const char *fName, CalculationResult *res){
	ofstream outfile;
	outfile.open(fName);
	VectorXd observProb = res->getObservationProbability();
	VectorXd qualityIndex = res->getQualityIndex();
	VectorXd frameNums = res->getFrameNums();
	int N = qualityIndex.rows();
	int M = frameNums.rows();
	int OP = observProb.rows();
	cout << "N= " << N <<  " M= "<< M <<  endl;

	for (int i = 0; i < N; i++){
		outfile << frameNums(i) << '\t' << qualityIndex(i);
		if (observProb.rows() > 0)
			outfile << '\t' << observProb(i);
		outfile << '\n';
	}
	outfile.close();

}

void FileProcessor::saveWeigts(const char *fName, MatrixXd wgts){
	writeMatrix(fName, wgts);
}

void FileProcessor::writeMatrix(const char* fname, MatrixXd m){
	ofstream outfile;
	outfile.open(fname);
	for (int i=0; i<m.rows(); i++){
		for (int j=0; j<m.cols(); j++){
			outfile << m(i,j) << '\t';
		}
		outfile << '\n';
	}
	outfile.close();
}
void FileProcessor::writeHSHist(const char *fName, Histogramm *hist){
	ofstream outfile;
	outfile.open(fName);
	cout << "writing hist.." << hist->hBins << " " << hist->sBins << " " << fName << endl;
	for (int h=0; h < hist->hBins; h++){
		for (int s=0; s<hist->sBins; s++){
			outfile << hist->hist.at<float>(h,s) << '\t';
		}
		outfile << '\n';
	}
	outfile.close();
}

Config* FileProcessor::readConfig(const char *fName){
	Config *cnf = new Config;

	ifstream inputFile;
	inputFile.open(fName, ifstream::in);
	string line;

	while (getline(inputFile, line)){
		if (line.compare("srcVideo") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->srcVideo = tmpLine; //line.c_str();
			cout << "srcVideo " << cnf->srcVideo << endl;
		} else if (line.compare("srcGT") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->srcGT = tmpLine;
			//cout << "srcGT " << cnf.srcGT << endl;
		} else if (line.compare("srcHist") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->srcHist = tmpLine;
			//cout << "srcHist " << cnf.srcHist << endl;
		} else if (line.compare("resName") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->res = tmpLine;
			//cout << "res " << cnf.res << endl;
		} else if (line.compare("gtType") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->gtTag = tmpLine;
			//cout << "gtType " << cnf.gtTag << endl;
		} else if (line.compare("adaptive") == 0){
			getline(inputFile, line);
			cnf->isAdaptive = (line.compare("true") == 0);

			//cout << "adaptive " << cnf.isAdaptive << endl;
		} else if (line.compare("updateModel") == 0){
			getline(inputFile, line);
			cnf->withUpdateModel = (line.compare("true") == 0);
		} else if (line.compare("devs") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			cout << "devs";
			for (int i=0; i<8; i++){
				iss >> cnf->devs[i];
				cout << " " << cnf->devs[i];
			}
			cout << endl;
			iss.clear();
		} else if (line.compare("resWeights") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->fNameWeights = tmpLine;
		} else if (line.compare("framesToInitName") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->fNameFramesToInit = tmpLine;
		} else if (line.compare("iterations") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->iterationsCount;
			iss.clear();
		} else if (line.compare("estimationsName") == 0){
			getline(inputFile, line);
			char *tmpLine = (char *) malloc(sizeof(char)*(line.length()+1));
			memcpy(tmpLine, line.c_str(), line.length()+1);
			cnf->fNameQualityEstimation = tmpLine;
		} else if (line.compare("N") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->N;
			iss.clear();
		} else if (line.compare("hBins") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->hBins;
			iss.clear();
		} else if (line.compare("sBins") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->sBins;
			iss.clear();
		} else if (line.compare("alpha") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->alpha;
			iss.clear();
		} else if (line.compare("beta") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->beta;
			iss.clear();
		} else if (line.compare("gamma") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->gamma;
			iss.clear();
		} else if (line.compare("threshold") == 0){
			getline(inputFile, line);
			istringstream iss(line);
			iss >> cnf->threshold;
			iss.clear();
		}
	}
	//istringstream iss(line);

	inputFile.close();

	return cnf;
}
