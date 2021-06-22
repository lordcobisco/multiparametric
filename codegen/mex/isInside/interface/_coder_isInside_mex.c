/*
 * _coder_isInside_mex.c
 *
 * Code generation for function '_coder_isInside_mex'
 *
 */

/* Include files */
#include "isInside.h"
#include "_coder_isInside_mex.h"
#include "isInside_terminate.h"
#include "_coder_isInside_api.h"
#include "isInside_initialize.h"
#include "isInside_data.h"

/* Function Declarations */
static void isInside_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
  const mxArray *prhs[3]);

/* Function Definitions */
static void isInside_mexFunction(int32_T nlhs, mxArray *plhs[2], int32_T nrhs,
  const mxArray *prhs[3])
{
  const mxArray *outputs[2];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 3) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 3, 4, 8,
                        "isInside");
  }

  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 8,
                        "isInside");
  }

  /* Call the function. */
  isInside_api(prhs, nlhs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(isInside_atexit);

  /* Module initialization. */
  isInside_initialize();

  /* Dispatch the entry-point. */
  isInside_mexFunction(nlhs, plhs, nrhs, prhs);

  /* Module termination. */
  isInside_terminate();
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_isInside_mex.c) */
