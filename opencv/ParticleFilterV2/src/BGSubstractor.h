/*
 * BGSubstractor.h
 *
 *  Created on: May 6, 2014
 *      Author: md
 */

#ifndef BGSUBSTRACTOR_H_
#define BGSUBSTRACTOR_H_
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/video/background_segm.hpp>

class BGSubstractor {
public:
	BGSubstractor();
	virtual ~BGSubstractor();
};

#endif /* BGSUBSTRACTOR_H_ */
