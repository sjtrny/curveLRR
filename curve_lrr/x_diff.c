#include <math.h>
#include <matrix.h>
#include <mex.h>
#include <string.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *in_pr = mxGetPr(prhs[0]);
    
    int n_rows = mxGetM(prhs[0]);
    int n_cols = mxGetN(prhs[0]);
    int n_total = n_rows * n_cols;
    int limit = n_total - n_rows;
    
    plhs[0] = mxCreateDoubleMatrix( n_rows, n_cols, mxREAL);
    double *out_pr = mxGetPr(plhs[0]);
    
//     for (int i = 0; i < n_rows; i++)
//     {
//         out_pr[i] = in_pr[i + n_rows] - in_pr[i];
//     }
    
    for (int i = n_rows; i < limit; i++)
    {
        out_pr[i] =  ((in_pr[i] - in_pr[i - n_rows])  +  (in_pr[i + n_rows] - in_pr[i])) / 2;
    }
    
//     for (int i = limit; i < n_total; i++)
//     {
//         out_pr[i] = in_pr[i] - in_pr[i - n_rows];
//     }
}