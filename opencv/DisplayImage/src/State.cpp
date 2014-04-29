/*
 * State.cpp
 *
 *  Created on: Apr 22, 2014
 *      Author: md
 */


#include "State.h"

State::State() {
	// TODO Auto-generated constructor stub
}

State::State(float x, float y, float w, float h, int frameNum){
	this->x = x > 0 ? x : 0;
	this->y = y > 0 ? y : 0;
	this->w = w > 1 ? w : 1;
	this->h = h > 1 ? h : 1;
	this->frameNum = frameNum;
}

State::State(Rect r, int frameNum){
	this->x = r.x > 0 ? r.x : 0;
	this->y = r.y > 0 ? r.y : 0;
	this->w = r.width > 1 ? r.width : 1;
	this->h = r.height > 1 ? r.height : 1;
	this->frameNum = frameNum;
}
State::~State() {
	// TODO Auto-generated destructor stub
}

Rect State::getRect(){
	return Rect(x,y,w,h);
}

double State::getQualityIndex(Rect r){
	Rect intersectRect = r & this->getRect();
	return (double)(intersectRect.width*intersectRect.height) / (double)(fmax(w*h, r.width*r.height));
}
