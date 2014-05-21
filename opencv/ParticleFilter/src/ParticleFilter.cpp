/*
 * ParticleFilter.cpp
 *
 *  Created on: Apr 24, 2014
 *      Author: md
 */

#include "ParticleFilter.h"

ParticleFilter::ParticleFilter(){
	// TODO Auto-generated constructor stub
}

ParticleFilter::ParticleFilter(int N, int hBins, int sBins, Histogramm *templHist, double initDevs[], int frameW, int frameH, int nFrames, bool adaptive)
{
	// TODO Auto-generated constructor stub
	this->N = N;
	this->hBins = hBins;
	this->sBins = sBins;
	this->templateHist = templHist;
	this->alpha = 8.0;
	this->beta = 0.5;
	this->wgtCoeff = 1/sqrt(0.02*M_PI);
	this->frameWidth = frameW;
	this->frameHeight = frameH;
	this->nFrames = nFrames;
	this->adaptive = adaptive;
	this->clusterNum = 0;
	A.resize(8,8);
	A.topLeftCorner(4,4).setIdentity();
	A.bottomLeftCorner(4,4).setZero();
	A.topRightCorner(4,4).setIdentity();
	A.bottomRightCorner(4,4).setIdentity();
	particles.resize(N, 10);
	initialDevs.resize(8);
	for (int i=0; i<8; i++)
		initialDevs[i] = initDevs[i];
	noiseGen = new WhiteNoiseGenerator();
	dists.resize(nFrames);
	qualityIndex.resize(nFrames);
}

/*
 * Private part
 */
// определить состояние объекта из набора частиц
void ParticleFilter::estimateState(){
	double x=0.0, y=0.0,w=0.0,h=0.0;


	for (int i=0; i<N; i++){
		double wgt = particles(i,8);
		x += particles(i,0)*wgt;
		y += particles(i,1)*wgt;
		w += particles(i,2)*wgt;
		h += particles(i,3)*wgt;
	}
	x = fmax(0, fmin(x, frameWidth-1));
	y = fmax(0, fmin(y, frameHeight-1));
	w = fmax(1, fmin(w, frameWidth-x-1));
	h = fmax(1, fmin(h, frameHeight-y-1));
	estimatedState = Rect(x, y, w, h);
}


/*
 * Public part
 */
// Подготовить набор частиц для первого кадра
void ParticleFilter::prepareFirstSet(Rect r){
	mt19937 mt_generator;
	mt_generator.seed( time(NULL) );
	uniform_real_distribution<double> ux(0.0, 1.0);
	uniform_real_distribution<double> uy(0.0, 1.0);
	double minX = r.x-r.width/2.0;
	double maxX = r.x + 1.5*r.width;
	double minY = r.y-r.height/2.0;
	double maxY = r.y + 1.5*r.height;
	double weight = 1.0/N;
	particles.block(0, 4, N, 4).setZero();
	particles.col(2).setConstant(r.width);
	particles.col(3).setConstant(r.height);
	particles.col(8).setConstant(weight);
	particles.col(9).setLinSpaced(1, N) * weight;
	for (int i=0; i<N; i++){
		double x = minX + (maxX - minX) * ux(mt_generator);
		double y = minY + (maxY - minY) * uy(mt_generator);
		particles(i,0) = x;
		particles(i,1) = y;

	}
	estimatedState = r;
}

void ParticleFilter::prepareFirstSetRandom(Rect r, double w, double h){
	mt19937 mt_generator;
	mt_generator.seed( time(NULL) );
	uniform_real_distribution<double> ux(0.0, 1.0);
	uniform_real_distribution<double> uy(0.0, 1.0);
	double weight = 1.0/N;
	particles.block(0, 4, N, 4).setZero();
	particles.col(2).setConstant(r.width);
	particles.col(3).setConstant(r.height);
	particles.col(8).setConstant(weight);
	particles.col(9).setLinSpaced(1, N) * weight;
	for (int i=0; i<N; i++){
		double x = w * ux(mt_generator);
		double y = h * uy(mt_generator);
		particles(i,0) = x;
		particles(i,1) = y;
	}
	estimateState();
}
// представление частиц в виде описывающих прямоугольников
Rect* ParticleFilter::getSetAsRects(){
	Rect* rects = new Rect[N];
	for (int i=0; i<N; i++){
		rects[i] = Rect(particles(i,0), particles(i,1), particles(i, 2), particles(i,3));
	}
	return rects;
}

// получить набор в виде точек
Point* ParticleFilter::getSetAsPoints(){
	Point *points = new Point[N];
	for (int i=0; i<N; i++){
		points[i] = Point(particles(i,0), particles(i,1));
	}
	return points;
}

// список весов с текущей итерации
VectorXd ParticleFilter::getWeights(){
	return particles.col(8);
}
// получить вычисленное состояние объекта как прямоугольник
Rect ParticleFilter::getEstimatedState(){
	return estimatedState;
}

void ParticleFilter::setClustersNum(int clNum){
	clusterNum = clNum;
	clusterCenters.resize(clusterNum);
	clusters.resize(clusterNum);
	clusterMap.resize(N);
	clusterCenters.setLinSpaced(1/(double)N*10, 1/(double)N*0.1);
	for (int i=0; i<clusterNum; i++){
		//clusterCenters(i) = 1/(double)N*pow(0.1,(double)i);
		cout << "center i: " << clusterCenters(i) << endl;
	}
}
// итерация алгоритма
void ParticleFilter::iter(Mat frame, int k){
	//cout << "estState: " << estimatedState.x << " " << estimatedState.y << " " << estimatedState.width << " " << estimatedState.height << endl;
	Mat estObj(frame, estimatedState);
	MatrixXd curSet(N, 10);
	curSet = particles;
	Histogramm *h = new Histogramm(estObj, hBins, sBins);;
	VectorXd devs(8);
	double dist;
	// adaptive part
	if (adaptive){
		dist = h->compare(templateHist);
		dists(k) = dist;
		double sigmoid = (erf(alpha*(dist-beta)) + 1.0) / 2.0;
		VectorXd devs(8);
		double minHW = fmin(estimatedState.width, estimatedState.height);
		double dynCoeff = 1-sigmoid;
		devs.head(4) = initialDevs.head(4) * sigmoid * minHW;
		devs.tail(4) = initialDevs.tail(4) * dynCoeff * minHW;
		curSet.block(0,4,N,4) = curSet.block(0,4,N,4) * dynCoeff;
		noiseGen->setCovar(devs);
	} else {
		noiseGen->setCovar(initialDevs);
	}

	particles.setZero(N, 10);

	mt19937 mt_generator;
	mt_generator.seed( time(NULL) );
	uniform_real_distribution<double> u(0.0, 1.0);

	for (int i=0; i<N; i++){
		double r = u(mt_generator);
		int j;
		for (j=0; j<N; j++){
			if (curSet(j,9) >= r){
				break;
			}
		}
		VectorXd v = noiseGen->nextSample().transpose();
		MatrixXd newParticle = A * curSet.block(j,0,1,8).transpose() + v;
		particles.block(i,0,1,8) = newParticle.transpose();
		particles(i,0) = fmax(0, fmin(particles(i,0), frameWidth-1));
		particles(i,1) = fmax(0, fmin(particles(i,1), frameHeight-1));
		particles(i,2) = fmax(1, fmin(particles(i,2), frameWidth-particles(i,0)-1));
		particles(i,3) = fmax(1, fmin(particles(i,3), frameHeight-particles(i,1)-1));
		Mat curMat(frame, Rect(particles(i,0), particles(i,1), particles(i,2), particles(i,3)));
		h->clear();
		h = new Histogramm(curMat, hBins, sBins);
		dist = h->compare(templateHist);
		particles(i,8) = wgtCoeff*exp(-dist/0.02);
		particles(i,9) = (i > 0) ? particles(i,8) + particles(i-1, 9) : particles(i,8);
	}

	particles.col(8) = particles.col(8) / particles(N-1, 9);
	particles.col(9) = particles.col(9) / particles(N-1, 9);
	if (clusterNum > 0)
		calcClusters();
	estimateState();
}

void ParticleFilter::calcClusters(){

	bool nextIter = true;
	int k=0;
	while (nextIter){
		k++;
		cout << "iter: " << k << endl;
		for (int i=0; i<clusterNum; i++){
			clusters[i].clear();
		}
		//cout << "cleared clusters" << endl;
		for (int j =0; j<N; j++){
			double minDist = 1;
			int minIndex = 0;
			for (int i=0; i<clusterNum; i++){
				double d = abs(particles(j,8)-clusterCenters(i));

				if (d < minDist){
					minDist = d;
					minIndex = i;
				}
			}
			clusters[minIndex].push_back(particles(j,8));
			clusterMap(j) = minIndex;
			//cout << j << " to " << minIndex << " with mindist " << minDist << endl;
		}

		nextIter = false;
		VectorXd newCenters(clusterNum);
		for (int i=0; i<clusterNum; i++){
			cout << "in cluster " << i << " " << clusters[i].size() << " elements " << endl;
			if (clusters[i].size() > 0){
				double mean = 0.0;
				for (int j=0; j<clusters[i].size(); j++){
					mean += clusters[i][j];

				}

				cout << "mean sum " << mean << endl;
				mean /= (double)clusters[i].size();
				newCenters(i) = mean;
			} else {
				newCenters(i) = clusterCenters(i);
			}
			cout << " new center " << i << " is " << newCenters(i) << endl;
			if (abs(newCenters(i)-clusterCenters(i)) > 1e-5){
				nextIter = true;
				cout << "next iter" << endl;
			}
			clusterCenters(i) = newCenters(i);
		}

	}
}

VectorXd ParticleFilter::getClusterMap(){
	return clusterMap;
}

MatrixXd ParticleFilter::getSetAsClusters(){
	MatrixXd clusterSet(N, 3);
	clusterSet.col(0) = particles.col(0);
	clusterSet.col(1) = particles.col(1);
	clusterSet.col(2) = clusterMap;
	return clusterSet;
}
ParticleFilter::~ParticleFilter() {
	// TODO Auto-generated destructor stub
}
