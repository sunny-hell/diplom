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
	if (x < 0) x=0;
	if (y < 0) y=0;
	if (w < 1) w=1;
	if (h < 1) h=1;
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

// представление частиц в виде описывающих прямоугольников
Rect* ParticleFilter::getSetAsRects(){
	Rect* rects = new Rect[N];
	for (int i=0; i<N; i++){
		rects[i] = Rect(particles(i,0), particles(i,1), particles(i, 2), particles(i,3));
	}
	return rects;
}
// получить вычисленное состояние объекта как прямоугольник
Rect ParticleFilter::getEstimatedState(){
	return estimatedState;
}

// итерация алгоритма
void ParticleFilter::iter(Mat frame, int k){
	//cout << estimatedState.x << " " << estimatedState.y << " " << estimatedState.width << " " << estimatedState.height << endl;
	Mat estObj(frame, estimatedState);
	MatrixXd curSet(N, 10);
	curSet = particles;
	Histogramm *h = new Histogramm(estObj, hBins, sBins);;
	VectorXd devs(8);
	double dist;
	// adaptive part
	if (adaptive){
		//h = new Histogramm(estObj, hBins, sBins);
		dist = h->compare(templateHist);
		dists(k) = dist;
		//cout << "dist: " << dist << endl;
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

	//cout << "after devs generated" << endl;


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
		//cout << "j=" << j << endl;
		VectorXd v = noiseGen->nextSample().transpose();

		MatrixXd newParticle = A * curSet.block(j,0,1,8).transpose() + v;

		particles.block(i,0,1,8) = newParticle.transpose();

		particles(i,0) = fmax(0, fmin(particles(i,0), frameWidth-1));
		particles(i,1) = fmax(0, fmin(particles(i,1), frameHeight-1));
		particles(i,2) = fmax(1, fmin(particles(i,2), frameWidth-particles(i,0)-1));
		particles(i,3) = fmax(1, fmin(particles(i,3), frameHeight-particles(i,1)-1));

		//cout << particles(i,0) << " " << particles(i,1) << " " << particles(i,2) << " " << particles(i,3) << endl;
		Mat curMat(frame, Rect(particles(i,0), particles(i,1), particles(i,2), particles(i,3)));

		h->clear();
		//cout << "after h clear" << endl;
		h = new Histogramm(curMat, hBins, sBins);
		dist = h->compare(templateHist);
		particles(i,8) = wgtCoeff*exp(-dist/0.02);
		particles(i,9) = (i > 0) ? particles(i,8) + particles(i-1, 9) : particles(i,8);
	}

	particles.col(8) = particles.col(8) / particles(N-1, 9);
	particles.col(9) = particles.col(9) / particles(N-1, 9);
	estimateState();
}


ParticleFilter::~ParticleFilter() {
	// TODO Auto-generated destructor stub
}
