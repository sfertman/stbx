#include "mex.h"
#include "matrix.h"
#include <math.h>

//TODO make this work with any nd array


void mexFunction(int nlhs, mxArray *plhs[], //outputs
                 int nrhs, const mxArray *prhs[]) //inputs
{
	double sum, nanCount;
	mwSize N = (mwSize)mxGetNumberOfElements(prhs[0]);
	double *arrIn = mxGetPr(prhs[0]);

	// Input validation
	if (nrhs > 1) mexErrMsgIdAndTxt("mex:stbx:matlab:nansum:err001","Too many input arguments.");
	if (nrhs < 1) mexErrMsgIdAndTxt("mex:stbx:matlab:nansum:err002","Not enough input arguments.");

	switch (nlhs) {
	case 0:
	case 1: // sum up everything without nans
		sum = 0;
		for(mwSize i = 0; i < N; i++) {
			sum += mxIsNaN(arrIn[i]) ? 0 : arrIn[i];
		}
		plhs[0] = mxCreateDoubleScalar(sum);
		//delete(sum);
		break;
	case 2: // sum up the doubles without NaNs and count the NaNs in vector
		nanCount = 0;
		for(mwSize i = 0; i < N; i++) {
			if(mxIsNaN(arrIn[i])) nanCount++;
			else sum += arrIn[i];
		}
		plhs[0] = mxCreateDoubleScalar(sum);
		plhs[1] = mxCreateDoubleScalar(nanCount); // made with double for now, probably should be should be mwSize.
		//delete(sum);
		//delete(nanCount);
		break;
	default:
		mexErrMsgIdAndTxt("mex:stbx:matlab:nansum:err003","Too many output arguments.");
	}

}
