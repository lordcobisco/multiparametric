/*
 * isInside_initialize.c
 *
 * Code generation for function 'isInside_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "isInside.h"
#include "isInside_initialize.h"
#include "_coder_isInside_mex.h"
#include "isInside_data.h"

/* Function Definitions */
void isInside_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

/* End of code generation (isInside_initialize.c) */
