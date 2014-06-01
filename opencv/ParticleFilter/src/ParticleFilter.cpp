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

ParticleFilter::ParticleFilter(int N, int hBins, int sBins, Histogramm *templHist, double initDevs[], int frameW, int frameH, int nFrames, bool adaptive, bool withUpdateModel)
{
	// TODO Auto-generated constructor stub
	/*
	this->N = N;
	this->hBins = hBins;
	this->sBins = sBins;
	this->templateHist = templHist;
	this->alpha = 8.0;
	this->beta = 0.5;
	this->wgtCoeff = 1/sqrt(0.02*M_PI);
	cout << wgtCoeff << endl;
	this->frameWidth = frameW;
	this->frameHeight = frameH;
	this->nFrames = nFrames;
	this->adaptive = adaptive;
	this->withUpdateModel = withUpdateModel;
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
	observationProbability.resize(nFrames);
	qualityIndex.resize(nFrames);
	*/
}

ParticleFilter::ParticleFilter(struct Config *cnf, Histogramm *templHist, int frameW, int frameH, int nFrames){
	this->cnf = cnf;
	this->templateHist = templHist;
	this->frameWidth = frameW;
	this->frameHeight = frameH;
	this->nFrames = nFrames;
	this->wgtCoeff = 1/sqrt(0.02*M_PI);
	this->N = cnf->N;
	A.resize(8,8);
	A.topLeftCorner(4,4).setIdentity();
	A.bottomLeftCorner(4,4).setZero();
	A.topRightCorner(4,4).setIdentity();
	A.bottomRightCorner(4,4).setIdentity();
	particles.resize(N, 10);
	noiseGen = new WhiteNoiseGenerator();
	dists.resize(nFrames);
	observationProbability.resize(nFrames);
	qualityIndex.resize(nFrames);
	initialDevs.resize(8);
	for (int i=0; i<8; i++)
		initialDevs[i] = cnf->devs[i];
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
	Point *p = new Point(r.x, r.y);
	prepareFirstSetAtPoint(r,p);

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

void ParticleFilter::prepareFirstSetAtPoint(Rect r, Point *p){
	mt19937 mt_generator;
	mt_generator.seed( time(NULL) );
	uniform_real_distribution<double> ux(0.0, 1.0);
	uniform_real_distribution<double> uy(0.0, 1.0);
	double minX = p->x-20;//r.width/2.0;
	double maxX = p->x+20;// 1.5*r.width;
	double minY = p->y-20;//r.height/2.0;
	double maxY = p->y+20;// 1.5*r.height;
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


// итерация алгоритма
void ParticleFilter::iter(Mat frame, int k){
	//cout << "estState: " << estimatedState.x << " " << estimatedState.y << " " << estimatedState.width << " " << estimatedState.height << endl;
	Mat estObj(frame, estimatedState);
	MatrixXd curSet(N, 10);
	curSet = particles;
	Histogramm *h = new Histogramm(estObj, cnf->hBins, cnf->sBins);
	//Histogramm *h = new Histogramm(estObj, 256); //cnf->hBins, cnf->sBins);
	VectorXd devs(8);
	double dist;

	// adaptive part
	if (cnf->isAdaptive || cnf->withUpdateModel ){
		dist = h->compare(templateHist);
		//cout << "dist: " << dist << endl;
		dists(k) = dist;
		if (cnf->withUpdateModel){
			//cout << "dist: " << dist << endl;
			//observationProbability(k) = wgtCoeff*exp(-dist/0.02);
			//cout << observationProbability(k) << endl;
			if (dist < cnf->threshold){
				/* update target model */
				for (int hb=0; hb < cnf->hBins; hb++){
					for (int sb=0; sb< cnf->sBins; sb++){
						templateHist->hist.at<float>(hb,sb) = (1-cnf->gamma)*templateHist->hist.at<float>(hb,sb) + cnf->gamma*h->hist.at<float>(hb,sb);
					}

				}
			}
		}
		if (cnf->isAdaptive){
			double sigmoid = (erf(cnf->alpha*(dist-cnf->beta)) + 1.0) / 2.0;
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
	} else {
		noiseGen->setCovar(initialDevs);
	}
	estObj = Mat();
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
		h = new Histogramm(curMat, cnf->hBins, cnf->sBins);
	//	h = new Histogramm(curMat, 256); //cnf->hBins, cnf->sBins);
		dist = h->compare(templateHist);
		particles(i,8) = wgtCoeff*exp(-dist/0.02);
		particles(i,9) = (i > 0) ? particles(i,8) + particles(i-1, 9) : particles(i,8);
		curMat = Mat();
	}

	particles.col(8) = particles.col(8) / particles(N-1, 9);
	particles.col(9) = particles.col(9) / particles(N-1, 9);

	estimateState();
}

ParticleFilter::~ParticleFilter() {
	// TODO Auto-generated destructor stub
}
