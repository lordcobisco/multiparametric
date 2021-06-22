/*
 * isInside_terminate.c
 *
 * Code generation for function 'isInside_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "isInside.h"
#include "isInside_terminate.h"
#include "_coder_isInside_mex.h"
#include "isInside_data.h"

/* Function Definitions */
void isInside_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

void isInside_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (isInside_terminate.c) */
