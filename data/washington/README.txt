This directory contains feature vectors (profiles/"time series") that were used
in the experiments in the following publication:

T. M. Rath and R. Manmatha: Word Image Matching Using Dynamic Time Warping.
In: Proc. of the Conf. on Computer Vision and Pattern Recognition (CVPR),
Madison, WI, June 18-20, 2003, vol. 2, pp. 521-527.

This data may only be used for research purposes. No commercial use is allowed.
We ask that anybody using the data cite the paper above.

Here is some information about the contents of this archive:
------------------------------------------------------------
1. The feature vectors in this directory were obtained from a collection of
   10 pages of George Washington's handwritten correspondence at the Library
   of Congress.
   Each of the 10 pages was segmented, resulting in a total of 2381 images of 
   words. The segmentation was performed automatically, so there are mistakes.
2. Each of the feature vectors is stored in a separate file, consecutively
   numbered features_1.dat, features_2.dat, ..., features_2381.dat.
   The format of the feature files is as follows (line-by-line):
   <length of feature vector N>
   feature1(1) feature2(1) feature3(1) feature4(1)
   feature1(2) feature2(2) feature3(2) feature4(2)
                         ...
   feature1(N) feature2(N) feature3(N) feature4(N)
   ----
   In Matlab, you can load a feature vector as follows:
   [f1 f2 f3 f4]=textread('feature_234.dat', '%f %f %f %f', 'headerlines', 1);
3. The file "relevance_judgment.txt" contains information about which images
   (or feature vectors) were considered to be "relevant" with respect to one
   another (in other words, the images/feature vectors match). 
   Two images that contain the same word were considered relevant. Here is an 
   example line in the file:
       7 Q0 322 1
   This line indicates that images 7 and 322 are considered relevant, i.e.
   the original images show two occurrences of the same word.
   Columns 2 and 4 ("Q0" and "1" in the example above) in the relevance file
   can be ignored, they do not contain additional information but are required
   if the relevance jdugment is to be used in a recall-precision analysis using
   the trec_eval program.
4. If you would like to obtain the original images, from which the features in
   this directory were extracted, please go to
   
        http://ciir.cs.umass.edu/downloads/

   and click on the button next to "Word Image Data Sets". Then proceed to
   download "Data set of good quality".


Scanned images of the original documents were provided to us by the Library of
Congress and this project was funded in part by the Center for Intelligent
Information Retrieval and in part by the National Science Foundation under
grant number IIS-9909073.

-------------------------------------------------
Toni M. Rath (trath@cs.umass.edu), 11/2003
Center for Intelligent Information Retrieval,
University of Massachusetts Amherst
