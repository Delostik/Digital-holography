# Digital-Holography Matlab Version #

## About this program ##
This program is used to reappear digital holography. It use fourier transform to process the origin interference image(by fourier lens), and captured by CCD, and reappear by inverse fourier transform.

To make the reappeared image clear, I use Laplace transform and window function(optional) to process the origin image before we do inverse fourier transform. And after transform, we provide mean filter and median filter to remove the noise(though the effect is not good enough).

## Why I do this ##
Because of the compulsory course —— The Normal Physics Experiment, and the sub-topic I choosed. The supporting software of this experiment is aweful(F□□k), and our result image is not clear enough, it may cause a low score...

## How to compile ##
In this version use matlab console and input

	mcc -m -e holography
The excutable file I provide is compiled my Microsoft Visual C++ 2013 Professional (C).
Also you can use following command to change your compiler

	mbuild -setup

## Copyright ##
Delostik @ Zhejiang Universiy
[My blog](http://www.delos96.com/ "Delostik's")
