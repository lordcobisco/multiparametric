/*
 * _coder_isInside_api.c
 *
 * Code generation for function '_coder_isInside_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "isInside.h"
#include "_coder_isInside_api.h"
#include "isInside_data.h"

/* Function Declarations */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[134524];
static const mxArray *b_emlrt_marshallOut(const real_T u);
static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *H_Sizes,
  const char_T *identifier))[199];
static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[199];
static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x0,
  const char_T *identifier))[12];
static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *H, const
  char_T *identifier))[134524];
static const mxArray *emlrt_marshallOut(const boolean_T u);
static real_T (*f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[12];
static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[134524];
static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[199];
static real_T (*i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[12];

/* Function Definitions */
static real_T (*b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[134524]
{
  real_T (*y)[134524];
  y = g_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static const mxArray *b_emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m1;
  y = NULL;
  m1 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m1);
  return y;
}

static real_T (*c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *H_Sizes,
  const char_T *identifier))[199]
{
  real_T (*y)[199];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = d_emlrt_marshallIn(sp, emlrtAlias(H_Sizes), &thisId);
  emlrtDestroyArray(&H_Sizes);
  return y;
}
  static real_T (*d_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u,
  const emlrtMsgIdentifier *parentId))[199]
{
  real_T (*y)[199];
  y = h_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*e_emlrt_marshallIn(const emlrtStack *sp, const mxArray *x0,
  const char_T *identifier))[12]
{
  real_T (*y)[12];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = f_emlrt_marshallIn(sp, emlrtAlias(x0), &thisId);
  emlrtDestroyArray(&x0);
  return y;
}
  static real_T (*emlrt_marshallIn(const emlrtStack *sp, const mxArray *H, const
  char_T *identifier))[134524]
{
  real_T (*y)[134524];
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = (const char *)identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(H), &thisId);
  emlrtDestroyArray(&H);
  return y;
}

static const mxArray *emlrt_marshallOut(const boolean_T u)
{
  const mxArray *y;
  const mxArray *m0;
  y = NULL;
  m0 = emlrtCreateLogicalScalar(u);
  emlrtAssign(&y, m0);
  return y;
}

static real_T (*f_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId))[12]
{
  real_T (*y)[12];
  y = i_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}
  static real_T (*g_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[134524]
{
  real_T (*ret)[134524];
  static const int32_T dims[3] = { 52, 13, 199 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 3U, dims);
  ret = (real_T (*)[134524])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*h_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[199]
{
  real_T (*ret)[199];
  static const int32_T dims[2] = { 1, 199 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 2U, dims);
  ret = (real_T (*)[199])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}
  static real_T (*i_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src,
  const emlrtMsgIdentifier *msgId))[12]
{
  real_T (*ret)[12];
  static const int32_T dims[1] = { 12 };

  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 1U, dims);
  ret = (real_T (*)[12])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

void isInside_api(const mxArray * const prhs[3], int32_T nlhs, const mxArray
                  *plhs[2])
{
  real_T (*H)[134524];
  real_T (*H_Sizes)[199];
  real_T (*x0)[12];
  boolean_T isin;
  real_T inwhich;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  H = emlrt_marshallIn(&st, emlrtAlias(prhs[0]), "H");
  H_Sizes = c_emlrt_marshallIn(&st, emlrtAlias(prhs[1]), "H_Sizes");
  x0 = e_emlrt_marshallIn(&st, emlrtAlias(prhs[2]), "x0");

  /* Invoke the target function */
  isInside(&st, *H, *H_Sizes, *x0, &isin, &inwhich);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(isin);
  if (nlhs > 1) {
    plhs[1] = b_emlrt_marshallOut(inwhich);
  }
}

/* End of code generation (_coder_isInside_api.c) */
