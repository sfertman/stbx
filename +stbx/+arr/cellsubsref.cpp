//+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
// CELLSUBSREF works basically like cellfun on subsref but at C++ breakneck 
// speeds. It doesn't support everything under the sun just yet but 
// the goal is to eventually support all possible Matlab/Octave classes and 
// cases.
//     
//     This file is part of STBX package.
//
//     STBX package is distributed in the hope that it will be useful and
//     it is absolutely free. You can do whatever you want with it as long
//     as it complies with GPLv3 license conditions. Read it in full at: 
//     <http://www.gnu.org/licenses/gpl-3.0.txt>. Needless to say that
//     this program comes WITHOUT ANY WARRANTY for ANYTHING WHATSOEVER. 
//   
//     On a personal note, if you do end up using any of my code, consider
//     sending me a note. I would like to hear about the cool new things my
//     code helped to make and get some inspiration for my future projects
//     too.
//     
//     Cheers.
//     -- Alexander F.
//+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

// See help in cellsubsref.m file soon

#include "mex.h"
#include "matrix.h"
#include <stdio.h>
#include <stdlib.h>

mwSize mxGetSizeOfType(mxClassID mxCID) {
	switch (mxCID) {
	//case mxUNKNOWN_CLASS: return 0;
	case mxCELL_CLASS: 		return (mwSize)sizeof(mxArray*);
	case mxSTRUCT_CLASS: 	return (mwSize)sizeof(mxArray*);
	case mxLOGICAL_CLASS: 	return (mwSize)sizeof(char);
	case mxCHAR_CLASS: 		return (mwSize)sizeof(char);
	//case mxVOID_CLASS:
	case mxDOUBLE_CLASS: 	return (mwSize)sizeof(double);
	case mxSINGLE_CLASS: 	return (mwSize)sizeof(float);
	case mxINT8_CLASS: 		return (mwSize)sizeof(char);
	case mxUINT8_CLASS:		return (mwSize)sizeof(char);
	case mxINT16_CLASS:		return (mwSize)sizeof(short);
	case mxUINT16_CLASS:	return (mwSize)sizeof(short);
	case mxINT32_CLASS: 	return (mwSize)sizeof(int);
	case mxUINT32_CLASS:	return (mwSize)sizeof(int);
	case mxINT64_CLASS:		return (mwSize)sizeof(long long);
	case mxUINT64_CLASS:	return (mwSize)sizeof(long long);
	//case mxFUNCTION_CLASS:    // TODO: to tell the truth, I have no idea what they are
	//case mxOPAQUE_CLASS: 		// TODO: to tell the truth, I have no idea what they are
	case mxOBJECT_CLASS:	return (mwSize)sizeof(mxArray*);
	default: return (mwSize)sizeof(mxArray*);
	}
}

/** This is not very efficient since I have to call it for each subs array member.
 * 	Try to think of a way to do this once and then use only one function.
 */
mxArray* mxCreateArrayByInput(const mxArray* inputArr, mwSize numel) { // #ok should be OK since all cases either throw e or return something
	char* e = "Unsupported input type. Cannot continue.\n";
	mxClassID mxCID = mxGetClassID(inputArr);
	switch (mxCID) {

	case mxCELL_CLASS: 		return mxCreateCellArray(1, &numel);
	case mxLOGICAL_CLASS: 	return mxCreateLogicalArray(1, &numel);
	case mxDOUBLE_CLASS:	// all numeric classes are treated the same way
	case mxSINGLE_CLASS: 	// all numeric classes are treated the same way
	case mxINT8_CLASS: 		// all numeric classes are treated the same way
	case mxUINT8_CLASS:		// all numeric classes are treated the same way
	case mxINT16_CLASS:		// all numeric classes are treated the same way
	case mxUINT16_CLASS:	// all numeric classes are treated the same way
	case mxINT32_CLASS: 	// all numeric classes are treated the same way
	case mxUINT32_CLASS:	// all numeric classes are treated the same way
	case mxINT64_CLASS:		// all numeric classes are treated the same way
	case mxUINT64_CLASS:	return mxCreateNumericArray(1, &numel, mxCID, mxIsComplex(inputArr) ? mxCOMPLEX : mxREAL);
	// All the following throw exception e
	case mxCHAR_CLASS: 		// TODO: char arrays (not cellstr) are not supported for now
	case mxSTRUCT_CLASS: 	// TODO: struct arrays are not supported for now
	case mxOBJECT_CLASS:	// TODO: this will require calling Matlab to construct classes -- can't see Self having the time for that any time soon
	case mxVOID_CLASS:		// TODO: to tell the truth, I have no idea what they are
	case mxOPAQUE_CLASS:	// TODO: to tell the truth, I have no idea what they are
	case mxUNKNOWN_CLASS: 	throw e; break;
	// case mxFUNCTION_CLASS:  // Matlab doesn't support function arrays. So, such a creature would not be seen in these parts.
	default: throw e; break;
	}

}

void memCopyBySize(void* to, size_t iTo, void* from, size_t iFrom, size_t elemSize) {
	/* from 	-- a pointer to the beginning of the memory block we're copying from
	 * to   	-- a pointer to the beginning of the memory block we're copying to
	 * iFrom 	-- the location where we're copying from in the 'from' memory block
	 * iTo  	-- the location where we're copying   to in the 'to'   memory block
	 * elemSize -- the size of the element we're copying
	 */

	char* e = "Unsupported input type. Cannot continue."; // exception to be thrown in case of unsupported input

	switch (elemSize) {
	case sizeof(char): {
		char *fromChar, *toChar;
		fromChar = (char*)from;
		toChar 	 = (char*)to;
		toChar[iTo] = fromChar[iFrom];
		break;
	}
	case sizeof(short): {
		short *fromShort, *toShort;
		fromShort = (short*)from;
		toShort 	 = (short*)to;
		toShort[iTo] = fromShort[iFrom];
		break;
	}
	case sizeof(float): { // identical sizes: int, long
		float *toFloat, *fromFloat;
		toFloat = (float *)to;
		fromFloat = (float *)from;
		toFloat[iTo] = fromFloat[iFrom];
		break;
	}
	case sizeof(double): { // identical sizes: long long
		double *toDouble, *fromDouble ;
		toDouble = (double *)to;
		fromDouble = (double *)from;
		toDouble[iTo] = fromDouble[iFrom];
		break;
	}
	default: throw e; break;
	}
}

void mexFunction(int nlhs, mxArray *plhs[], //outputs
                 int nrhs, const mxArray *prhs[]) //inputs
{
	// inputs
	//const mwSize *subs_dims, *arrIn_dims; // inputs' dimension arrays
	//mwSize arrIn_ndims, subs_ndims; // inputs' number of dimensions (lengths or respective arrays)
	//sldkslkdlsk
    if(mxIsEmpty(prhs[0])) {
    	mexErrMsgIdAndTxt("mex:cellsubsref", "Input array is empty. I believe one cannot reference members of an empty array.\n");
    }

	mwSize arrIn_numel = (mwSize)mxGetNumberOfElements(prhs[0]);

	//outputs

	//mxArray *cellout;
	void *voidArrCellElem;
	//const mxClassID inputClass = mxGetClassID(prhs[0]);
	//const mwSize sizeOfInputClass = mxGetSizeOfType(inputClass);
	mwSize sizeOfInputClass = mxGetSizeOfType(mxGetClassID(prhs[0]));
	mxArray* celloutElem;

	// processing
	//mxArray *subs_temp; // temp storage for subscript indices
	//mxArray *mmbr_temp; // temp storage for referenced members


	//input checks
	if (nrhs != 2) mexErrMsgIdAndTxt("mex:cellsubsref", "Not enough input arguments. Two (2) are expected for this function.\n");
	if (mxGetClassID(prhs[1]) != mxCELL_CLASS) mexErrMsgIdAndTxt("mex:cellsubsref","Second function argument must be a cell.");


	//output checks
	if (nlhs > 1) mexErrMsgIdAndTxt("mex:cellsubsref", "Too many output arguments. One (1) argument is expected for this function.\n");

	//arrIn_dims = mxGetDimensions(prhs[0]);
	//arrIn_ndims = mxGetNumberOfDimensions(prhs[0]);
	//arrIn_numel = (mwSize)mxGetNumberOfElements(prhs[0]);
	//mxArray *subs = (mxArray *)mxGetData(prhs[1]);
	
	// create output cell array--same size as input subs cell array
	//mxFree(mxGetData(plhs[0]));
	plhs[0] = mxCreateCellArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]));

	//mwSize ii = (mwSize)mxGetNumberOfElements(prhs[1]);
	for (mwIndex i = 0; i < (mwSize)mxGetNumberOfElements(prhs[1]); i++) {
		mxArray *subsCellElement = mxGetCell(prhs[1], i);
		mwSize jj;
		if (mxIsEmpty(subsCellElement)) {
			jj = 0;
		}
		else {
			jj = (mwSize)mxGetNumberOfElements(subsCellElement); // this will fail if input is empty
		}

		
		// Making sure that the input subs are of type double
		if (mxGetClassID(subsCellElement) != mxDOUBLE_CLASS) mexErrMsgIdAndTxt("mex:cellsubsref", "Only double subscripts are supported for now.\n");
		/* The following statement is assuming that the subs are given as doubles,
		 * anything else will make this line crash. This is why we check the type
		 * in the above ^ line. TODO: Make this work with other data types
		*/
		double *subsCellElementContent = mxGetPr(subsCellElement);

		try {
			celloutElem = mxCreateArrayByInput(prhs[0], jj);
		}
		catch (char* e) {
			mexErrMsgIdAndTxt("mex:cellsubsref", e);
		}

		// Get void pointer to the data
		voidArrCellElem = mxGetData(celloutElem);

		for (mwIndex j = 0; j < jj; j++) {

			mwSize idxFrom = (mwSize)(subsCellElementContent[j]-1); //This is where we're copying from
			if (idxFrom >= arrIn_numel) { // making sure Matlab doesn't crash due to index out of bounds
				char buffer[100];
				sprintf(buffer,"Index out of bounds at cell %d element %d.\n",i,j);
				mexErrMsgIdAndTxt("mex:cellsubsref", buffer);
			}

			if (mxGetClassID(celloutElem) == mxCELL_CLASS) {

				mxSetCell(celloutElem, j, mxDuplicateArray(mxGetCell(prhs[0],idxFrom))); // copy from cell to cell
			}
			else {
				try {
					memCopyBySize(voidArrCellElem, j, mxGetData(prhs[0]), idxFrom, sizeOfInputClass);
				}
				catch (char* e){
					mexErrMsgIdAndTxt("mex:cellsubsref", e);
				}
			}
		}

		mxSetCell(plhs[0], i, celloutElem); // putting the temp array in its place within the output cell
	}
}


